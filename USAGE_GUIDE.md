# Hadoop & Spark Salary Analysis Project - Usage Guide

This guide explains how to use all the scripts in this project to build, run the analysis, and generate comprehensive reports using both Hadoop MapReduce and Apache Spark.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Overview](#project-overview)
3. [Building the Project](#building-the-project)
4. [Running the Analysis](#running-the-analysis)
5. [Generating Reports](#generating-reports)
6. [Complete Workflow](#complete-workflow)
7. [Script Descriptions](#script-descriptions)
8. [Spark Integration](#spark-integration)

## Prerequisites

- Java 11 or higher
- Hadoop 3.x installed and configured
- Apache Spark 3.x installed (for Spark analysis)
- CSV dataset file in the input directory

## Project Overview

This project contains two main analyses available in both Hadoop MapReduce and Apache Spark implementations:

1. **Skills Analysis**: Analyzes the frequency of technical skills mentioned in job descriptions
2. **Salary Analysis**: Analyzes salary statistics for different job titles

Each analysis has been implemented using both technologies to demonstrate different big data processing frameworks.

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

### Hadoop MapReduce Scripts

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
| `capture_evidence.sh` | Captures execution evidence (screenshots, file lists, etc.)|

### Apache Spark Scripts

| Script | Description |
|--------|-------------|
| `build_spark.sh` | Compiles the Spark analysis Java files and creates the spark-analyzer.jar |
| `run_spark_analysis.sh` | Runs the specified Spark analysis (salary or skills) |
| `generate_spark_report.sh` | Generates comprehensive reports for Spark-based analysis |
| `run_spark_simulation.sh` | Simulates Spark analysis without requiring a full Spark installation |
| `generate_spark_report_simple.sh` | Simplified report generator that works with both real and simulated Spark output | |

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

## Spark Integration

This project now includes Apache Spark implementations of the same analyses to demonstrate the differences and advantages between Hadoop MapReduce and Spark.

### Building Spark Jobs

To build the Spark version of the analysis:

```bash
./build_spark.sh
```

This compiles the SparkSalaryAnalyzer and SparkSkillsAnalyzer classes and packages them into spark-analyzer.jar.

### Running Spark Analysis

To run a Spark analysis:

```bash
./run_spark_analysis.sh <analysis_type> <input_path> <output_path>
```

Where:
- `analysis_type`: Either "salary" or "skills"
- `input_path`: Path to the input data file
- `output_path`: Directory for the output results

Examples:
```bash
# Run Spark Salary Analysis
./run_spark_analysis.sh salary input/job_descriptions.csv output/spark_salary_analysis

# Run Spark Skills Analysis
./run_spark_analysis.sh skills input/job_descriptions.csv output/spark_skills_analysis
```

### Generating Spark Reports

To generate a report from Spark analysis results:

```bash
./generate_spark_report.sh <analysis_type> <output_directory>
```

Examples:
```bash
# Generate Spark Salary Analysis Report
./generate_spark_report.sh salary output/spark_salary_analysis

# Generate Spark Skills Analysis Report
./generate_spark_report.sh skills output/spark_skills_analysis
```

### Complete Spark Workflow

For a complete Spark analysis, follow these steps:

#### Option 1: With Full Spark Installation

```bash
# 1. Build the Spark analyzer
./build_spark.sh

# 2. Run the Spark salary analysis
./run_spark_analysis.sh salary input/job_descriptions.csv output/spark_salary_analysis

# 3. Generate the salary report
./generate_spark_report.sh salary output/spark_salary_analysis

# 4. Run the Spark skills analysis
./run_spark_analysis.sh skills input/job_descriptions.csv output/spark_skills_analysis

# 5. Generate the skills report
./generate_spark_report.sh skills output/spark_skills_analysis
```

#### Option 2: Using Simulation (No Spark Required)

If you don't have Spark installed, you can use our simulation scripts to generate realistic output:

```bash
# 1. Run the Spark salary analysis simulation
./run_spark_simulation.sh salary input/job_descriptions.csv output/spark_salary_analysis

# 2. Generate the salary report (using simplified generator)
./generate_spark_report_simple.sh salary output/spark_salary_analysis

# 3. Run the Spark skills analysis simulation
./run_spark_simulation.sh skills input/job_descriptions.csv output/spark_skills_analysis

# 4. Generate the skills report (using simplified generator)
./generate_spark_report_simple.sh skills output/spark_skills_analysis
```

### Performance Comparison

The Spark implementation offers several advantages over Hadoop MapReduce:

1. **Speed**: In-memory processing allows for faster computation
2. **Ease of Use**: More concise code with a simpler API
3. **Interactive Analysis**: Support for interactive queries and analysis
4. **ML Integration**: Built-in machine learning library for advanced analytics
5. **Unified Platform**: Same framework for batch, streaming, and interactive processing

Each implementation has its strengths, and this project allows you to compare both approaches directly.

### Spark Troubleshooting

If you encounter issues with the Spark integration:

1. **Missing Spark Installation**:
   - If you don't have Spark installed, you can use the `run_spark_simulation.sh` script instead of `run_spark_analysis.sh`.
   - The simulation script generates sample output data that can be used with the report generators.

2. **Compatibility Issues**:
   - If you get errors about Spark classes not found, verify that your Spark installation is compatible with Java 11.
   - Update the `SPARK_HOME` variable in `build_spark.sh` and `run_spark_analysis.sh` to point to your Spark installation.

3. **Report Generation Issues**:
   - If `generate_spark_report.sh` fails, try using the simplified version `generate_spark_report_simple.sh`.
   - The simplified generator is more tolerant of different output formats.

4. **Java Errors During Build**:
   - Make sure your `JAVA_HOME` points to a Java 11 installation.
   - Check that all required paths in `build_spark.sh` are correct for your system.

### Comparing MapReduce and Spark Results

For an educational comparison of MapReduce and Spark:

1. Run both analyses on the same dataset:
```bash
# MapReduce Salary Analysis
./run_salary_analysis.sh input/job_descriptions.csv output/full_salary_analysis

# Spark Salary Analysis (or simulation)
./run_spark_analysis.sh salary input/job_descriptions.csv output/spark_salary_analysis
# Or
./run_spark_simulation.sh salary input/job_descriptions.csv output/spark_salary_analysis
```

2. Generate reports for both:
```bash
# MapReduce Report
./generate_comprehensive_report.sh output/full_salary_analysis

# Spark Report
./generate_spark_report_simple.sh salary output/spark_salary_analysis
```

3. Compare the reports to understand differences in approach, performance, and results.
