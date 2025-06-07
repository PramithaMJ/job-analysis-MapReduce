# Python Implementation for Hadoop Salary Analysis

This folder contains the Python implementation of the salary analysis pipeline using Hadoop Streaming, which allows MapReduce jobs to be written in Python.

## Contents


| File                        | Description                                                                   |
| --------------------------- | ----------------------------------------------------------------------------- |
| `salary_mapper.py`          | The mapper script that processes job listings and extracts salary information |
| `salary_reducer.py`         | The reducer script that aggregates salary statistics by job title             |
| `runner.sh`                 | Shell script to execute the Hadoop Streaming job                              |
| `view.sh`                   | Shell script to view the results in HDFS                                      |
| `generate_salary_report.py` | Python script to generate a PDF report from the results                       |
| `Salary_Report.pdf`         | The generated PDF salary analysis report                                      |

## Implementation Details

### Mapper (`salary_mapper.py`)

The mapper processes job listing data and extracts salary information:

- Parses input lines using CSV format
- Extracts job titles from the data
- Uses regular expressions to parse salary ranges (e.g., "$50K - $70K")
- Emits key-value pairs with job title as key and salary information as value

### Reducer (`salary_reducer.py`)

The reducer aggregates salary information by job title:

- Processes the key-value pairs from the mapper
- For each job title, calculates:
  - Minimum salary
  - Maximum salary
  - Average salary
  - Count of listings
- Outputs the statistics in a tab-separated format

### Report Generator (`generate_salary_report.py`)

Generates a professional PDF report from the MapReduce results:

- Reads data from HDFS output
- Parses the salary statistics
- Creates formatted tables and charts
- Generates a PDF report with ReportLab

## How to Use

### 1. Run the Hadoop Job

```bash
./runner.sh
```

This executes the Hadoop Streaming job with the Python mapper and reducer.

### 2. View the Results

```bash
./view.sh
```

This displays the output files in HDFS.

### 3. Generate the Report

```bash
python3 generate_salary_report.py
```

This creates the `Salary_Report.pdf` file with formatted results.

## Requirements

- Python 3.x
- Hadoop with Streaming support
- ReportLab Python library (for PDF generation)
- Access to the job listings dataset in HDFS at `/user/tharindu/input`

## Integration

This Python implementation provides an alternative to the Java version in the main project directory. The results from both implementations can be compared for validation purposes.
