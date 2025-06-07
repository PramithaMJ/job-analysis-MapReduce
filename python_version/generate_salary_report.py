#!/usr/bin/env python3

import subprocess
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from io import StringIO

# === CONFIGURATION ===
HDFS_OUTPUT_PATH = "/user/tharindu/output/part-00000"
PDF_OUTPUT_PATH = "Salary_Report.pdf"

# === READ DATA FROM HDFS ===
def read_hdfs_output(hdfs_path):
    try:
        # Run Hadoop fs -cat to read data from HDFS
        cmd = ["hadoop", "fs", "-cat", hdfs_path]
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        return result.stdout.strip().split('\n')
    except subprocess.CalledProcessError as e:
        print(f"Error reading from HDFS: {e.stderr}")
        return []

# === PARSE DATA ===
def parse_data(lines):
    data = []
    for line in lines:
        try:
            title, values = line.strip().split('\t')
            min_salary, max_salary, avg_salary, count = map(float, values.split(','))
            data.append([
                title,
                f"${min_salary:,.2f}",
                f"${max_salary:,.2f}",
                f"${avg_salary:,.2f}",
                int(count)
            ])
        except Exception:
            continue
    return data

# === GENERATE PDF ===
def generate_pdf(data, output_file):
    doc = SimpleDocTemplate(output_file, pagesize=A4)
    styles = getSampleStyleSheet()
    elements = []

    # Title
    elements.append(Paragraph("Job Salary Report", styles['Title']))
    elements.append(Spacer(1, 12))

    # Table headers
    table_data = [["Job Title", "Min Salary", "Max Salary", "Avg Salary", "Count"]] + data

    # Style the table
    table = Table(table_data, repeatRows=1, hAlign='LEFT')
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
        ("ALIGN", (1, 1), (-1, -1), "RIGHT"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 8),
        ("BACKGROUND", (0, 1), (-1, -1), colors.beige),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.black),
    ]))

    elements.append(table)
    doc.build(elements)
    print(f"PDF report saved as: {output_file}")

# === MAIN ===
if __name__ == "__main__":
    hdfs_lines = read_hdfs_output(HDFS_OUTPUT_PATH)
    if not hdfs_lines:
        print("No data found in HDFS output.")
    else:
        parsed_data = parse_data(hdfs_lines)
        generate_pdf(parsed_data, PDF_OUTPUT_PATH)
