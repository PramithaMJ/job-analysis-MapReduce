# Project Structure and Files

This document provides a detailed overview of the project's file structure and the purpose of each component.

## Main Directories

### `/src` - Source Code
Contains all Java source files for both Hadoop MapReduce and Spark implementations.

### `/classes` - Compiled Classes
Contains compiled Java classes for the Hadoop MapReduce implementation.

### `/spark_classes` - Spark Compiled Classes
Contains compiled Java classes for the Spark implementation.

### `/input` - Input Data
Contains the job descriptions dataset file.

### `/output` - Analysis Results
Contains output directories from various analysis runs.

### `/conf` - Configuration Files
Contains Hadoop configuration files for local execution.

### `/python_version` - Python Implementation
Contains a Python implementation of the salary analysis.

### `/screenshots` - Execution Evidence
Contains screenshots and text logs documenting the execution of various components.

## Script Files

### Build Scripts
| Script | Purpose |
|--------|---------|
| `build.sh` | Builds the skills analysis MapReduce job |
| `build_salary.sh` | Builds the salary analysis MapReduce job |
| `build_spark.sh` | Builds the Spark analysis jobs |

### Execution Scripts
| Script | Purpose |
|--------|---------|
| `run_local.sh` | Runs the skills analysis in local mode |
| `run_salary.sh` | Simple script for running the salary analysis |
| `run_salary_analysis.sh` | Comprehensive script for running the salary analysis with detailed output |
| `run_spark_analysis.sh` | Runs either salary or skills analysis in Spark |
| `run_spark_simulation.sh` | Simulates Spark analysis without requiring a full Spark installation |

### Report Generation Scripts
| Script | Purpose |
|--------|---------|
| `generate_report.sh` | Generates a report for the skills analysis |
| `generate_salary_report.sh` | Generates a basic report for the salary analysis |
| `generate_comprehensive_report.sh` | Generates a comprehensive salary analysis report |
| `generate_spark_report.sh` | Generates reports for Spark-based analysis |
| `generate_spark_report_simple.sh` | Simplified report generator for Spark analysis |
| `capture_evidence.sh` | Captures execution evidence (screenshots, file lists, etc.) |

## Source Code Files

### Hadoop MapReduce Implementation
| File | Purpose |
|------|---------|
| `SalaryMapper.java` | Maps job titles to salary information |
| `SalaryReducer.java` | Aggregates salary statistics by job title |
| `SalaryAnalyzer.java` | Driver class for the salary analysis job |
| `SkillsMapper.java` | Maps job descriptions to skills |
| `SkillsReducer.java` | Counts skill occurrences |
| `SkillsAnalyzer.java` | Driver class for the skills analysis job |

### Spark Implementation
| File | Purpose |
|------|---------|
| `SparkSalaryAnalyzer.java` | Spark implementation of the salary analysis |
| `SparkSkillsAnalyzer.java` | Spark implementation of the skills analysis |

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Main project overview and quick start guide |
| `PROJECT_SUMMARY.md` | Detailed technical summary of the project |
| `USAGE_GUIDE.md` | Comprehensive usage instructions for all scripts |
| `PROJECT_README.md` | Detailed technical implementation details |

## Report Files

| File | Purpose |
|------|---------|
| `COMPREHENSIVE_SALARY_REPORT.md` | Detailed salary analysis from MapReduce |
| `SALARY_ANALYSIS_REPORT.md` | Basic salary statistics report |
| `RESULTS_ANALYSIS.md` | Analysis of the skills frequency results |
| `SPARK_SALARY_ANALYSIS_REPORT.md` | Salary analysis using Spark |
| `SPARK_SKILLS_ANALYSIS_REPORT.md` | Skills analysis using Spark |

## Output Directories

| Directory | Purpose |
|-----------|---------|
| `output/full_salary_analysis/` | Main salary analysis results |
| `output/salary_analysis/` | Additional salary analysis results |
| `output/skills_analysis_local/` | Skills analysis results |
| `output/spark_salary_analysis/` | Spark salary analysis results |
| `output/spark_skills_analysis/` | Spark skills analysis results |

## Python Implementation

The `/python_version` directory contains an alternative Python implementation of the salary analysis, including:

| File | Purpose |
|------|---------|
| `salary_mapper.py` | Python version of the salary mapper |
| `salary_reducer.py` | Python version of the salary reducer |
| `generate_salary_report.py` | Python script for generating reports |
| `runner.sh` | Script to run the Python MapReduce job |
| `view.sh` | Script to view the generated report |
| `Salary_Report.pdf` | PDF version of the salary report |
