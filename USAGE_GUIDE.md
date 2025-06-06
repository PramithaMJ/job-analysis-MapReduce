# Hadoop Salary Analysis Project - Usage Guide

This guide explains how to use all the scripts in this project to build, run the analysis, and generate comprehensive reports.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Overview](#project-overview)
3. [Building the Project](#building-the-project)
4. [Running the Analysis](#running-the-analysis)
5. [Generating Reports](#generating-reports)
6. [Complete Workflow](#complete-workflow)
7. [Script Descriptions](#script-descriptions)

## Prerequisites

- Java 11 or higher
- Hadoop 3.x installed and configured
- CSV dataset file in the input directory

## Project Overview

This project contains two main analyses:

1. **Skills Analysis**: Analyzes the frequency of technical skills mentioned in job descriptions
2. **Salary Analysis**: Analyzes salary statistics for different job titles

## Building the Project

### Building the Salary Analyzer

```bash
./build_salary.sh
```

This will:
- Compile the Java source files (SalaryMapper.java, SalaryReducer.java, SalaryAnalyzer.java)
- Create the salary-analyzer.jar file

### Building the Skills Analyzer

```bash
./build.sh
```

This will:
- Compile the Java source files (SkillsMapper.java, SkillsReducer.java, SkillsAnalyzer.java)
- Create the skills-analyzer.jar file

## Running the Analysis

### Running the Salary Analysis

```bash
./run_salary_analysis.sh <input_path> <output_path>
```

Example:
```bash
./run_salary_analysis.sh input/job_descriptions.csv output/full_salary_analysis
```

This script:
- Sets up the environment for local Hadoop execution
- Runs the SalaryAnalyzer MapReduce job
- Shows a sample of the results after completion

### Running the Skills Analysis

```bash
./run_local.sh
```

This runs the Skills Analyzer in local mode with default input/output paths.

## Generating Reports

### Basic Salary Report

```bash
./generate_salary_report.sh [output_directory]
```

Example:
```bash
./generate_salary_report.sh output/full_salary_analysis
```

This generates a basic salary analysis report.

### Comprehensive Salary Report

```bash
./generate_comprehensive_report.sh [output_directory]
```

Example:
```bash
./generate_comprehensive_report.sh output/full_salary_analysis
```

This generates a comprehensive salary analysis report with:
- Executive summary
- Key findings
- Top paying jobs
- Lowest paying jobs
- Most common job titles
- Complete salary statistics
- Methodology
- Analysis insights
- Recommendations

The report is saved as `COMPREHENSIVE_SALARY_REPORT.md` in the current directory.

### Skills Analysis Report

```bash
./generate_report.sh
```

This generates a report for the skills analysis results.

## Complete Workflow

For a full analysis, follow these steps in order:

### 1. Skills Analysis Workflow

```bash
# Build the Skills Analyzer
./build.sh

# Run the Skills Analysis
./run_local.sh

# Generate the Skills Analysis Report
./generate_report.sh
```

### 2. Salary Analysis Workflow

```bash
# Build the Salary Analyzer
./build_salary.sh

# Run the Salary Analysis
./run_salary_analysis.sh input/job_descriptions.csv output/full_salary_analysis

# Generate the Comprehensive Salary Report
./generate_comprehensive_report.sh output/full_salary_analysis
```

## Script Descriptions

| Script | Description |
|--------|-------------|
| `build.sh` | Compiles the skills analysis Java files and creates the skills-analyzer.jar |
| `build_salary.sh` | Compiles the salary analysis Java files and creates the salary-analyzer.jar |
| `run_local.sh` | Runs the skills analysis in local mode |
| `run_salary.sh` | Simple script to run the salary analysis |
| `run_salary_analysis.sh` | Comprehensive script to run the salary analysis with detailed output |
| `generate_report.sh` | Generates a report for the skills analysis |
| `generate_salary_report.sh` | Generates a basic report for the salary analysis |
| `generate_comprehensive_report.sh` | Generates a comprehensive salary analysis report |
| `capture_evidence.sh` | Captures execution evidence (screenshots, file lists, etc.) |

## Viewing Reports

After generating the reports, you can view them with any Markdown viewer:

```bash
# For comprehensive salary report
open COMPREHENSIVE_SALARY_REPORT.md

# For salary analysis report
open SALARY_ANALYSIS_REPORT.md

# For results analysis
open RESULTS_ANALYSIS.md
```

## Troubleshooting

If you encounter issues:

1. Make sure Java and Hadoop are properly installed and configured
2. Check that the input file exists and has the correct format
3. Ensure you have write permissions for the output directory
4. Check execution logs for specific error messages

For detailed information about the technical implementation, refer to `PROJECT_README.md`.
