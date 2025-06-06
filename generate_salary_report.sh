#!/bin/bash
# -------------------------------------------------------
# Salary Analysis - Report Generator
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "          GENERATING SALARY ANALYSIS REPORT                  "
echo "============================================================="
echo "Date: $(date)"
echo

# Check if output directory was provided, otherwise use default
OUTPUT_DIR="${1:-output/salary_local_test}"
REPORT_FILE="SALARY_ANALYSIS_REPORT.md"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' not found."
    echo "Usage: ./generate_salary_report.sh [output_directory]"
    exit 1
fi

# Check if part-r-00000 file exists in the output directory
if [ ! -f "$OUTPUT_DIR/part-r-00000" ]; then
    echo "Error: Results file '$OUTPUT_DIR/part-r-00000' not found."
    echo "Make sure the MapReduce job completed successfully."
    exit 1
fi

echo "Analyzing salary data in $OUTPUT_DIR..."
echo

# Create the report file
cat > $REPORT_FILE << EOL
# Salary Analysis Report
**Generated on:** $(date)

## Overview
This report analyzes salary data from job listings processed with Hadoop MapReduce.

## Salary Statistics by Job Title

| Job Title | Min Salary | Max Salary | Avg Salary | Count |
|-----------|------------|------------|------------|-------|
EOL

# Process the part-r-00000 file to extract data for the report
while IFS=$'\t' read -r title stats; do
    # Extract values from the stats string (min,max,avg,count format)
    IFS=',' read -r min max avg count <<< "$stats"
    
    # Format values for better readability
    min_formatted=$(printf "$%'.2f" $min)
    max_formatted=$(printf "$%'.2f" $max)
    avg_formatted=$(printf "$%'.2f" $avg)
    
    # Add the data to the report
    echo "| $title | $min_formatted | $max_formatted | $avg_formatted | $count |" >> $REPORT_FILE
done < "$OUTPUT_DIR/part-r-00000"

# Calculate overall statistics
echo -e "\n## Summary Statistics" >> $REPORT_FILE

# Calculate total jobs analyzed
total_count=$(awk -F',' '{sum += $4} END {print sum}' "$OUTPUT_DIR/part-r-00000")

# Calculate overall average salary
avg_salary=$(awk -F',' '{sum += $3 * $4; count += $4} END {printf "%.2f", sum/count}' "$OUTPUT_DIR/part-r-00000")
avg_formatted=$(printf "$%'.2f" $avg_salary)

# Find highest and lowest salary jobs
highest_job=$(sort -t$'\t' -k2.9 -nr "$OUTPUT_DIR/part-r-00000" | head -1)
IFS=$'\t' read -r high_title high_stats <<< "$highest_job"
IFS=',' read -r high_min high_max high_avg high_count <<< "$high_stats"
high_avg_formatted=$(printf "$%'.2f" $high_avg)

lowest_job=$(sort -t$'\t' -k2.9 -n "$OUTPUT_DIR/part-r-00000" | head -1)
IFS=$'\t' read -r low_title low_stats <<< "$lowest_job"
IFS=',' read -r low_min low_max low_avg low_count <<< "$low_stats"
low_avg_formatted=$(printf "$%'.2f" $low_avg)

# Add summary data to report
cat >> $REPORT_FILE << EOL
- **Total Job Titles Analyzed:** $total_count
- **Overall Average Salary:** $avg_formatted
- **Highest Paying Job:** $high_title ($high_avg_formatted)
- **Lowest Paying Job:** $low_title ($low_avg_formatted)

## Methodology
The salary data was processed using a Hadoop MapReduce job that:
1. Parsed salary ranges from job listings (e.g., "$50K - $100K")
2. Calculated average salaries for each job title
3. Aggregated statistics by job title to find minimums, maximums, and averages

## System Information
- **Date:** $(date)
- **Hadoop Version:** $(hadoop version | head -1)
- **User:** $(whoami)
- **Platform:** $(uname -a)
EOL

echo "Report generation complete!"
echo "Report saved to $REPORT_FILE"
echo "============================================================="

# Open the report in a text editor if available
if command -v open > /dev/null; then
    open $REPORT_FILE
elif command -v xdg-open > /dev/null; then
    xdg-open $REPORT_FILE
fi
