#!/bin/bash
# -------------------------------------------------------
# Spark Analysis - Simple Report Generator
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "    GENERATING SPARK ANALYSIS REPORT (SIMPLIFIED)            "
echo "============================================================="
echo "Date: $(date)"
echo

# Check if report type and output directory were provided
if [ $# -lt 2 ]; then
    echo "Usage: ./generate_spark_report_simple.sh <analysis_type> <output_directory>"
    echo "Example: ./generate_spark_report_simple.sh salary output/spark_salary_analysis"
    echo "Example: ./generate_spark_report_simple.sh skills output/spark_skills_analysis"
    exit 1
fi

ANALYSIS_TYPE=$1
OUTPUT_DIR=$2
REPORT_FILE="SPARK_${ANALYSIS_TYPE}_ANALYSIS_REPORT.md"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' not found."
    exit 1
fi

# Check if result files exist in the output directory
if [ ! -f "$OUTPUT_DIR/part-00000" ]; then
    echo "Error: Results file '$OUTPUT_DIR/part-00000' not found."
    echo "Make sure the Spark job completed successfully."
    exit 1
fi

echo "Analyzing $ANALYSIS_TYPE data in $OUTPUT_DIR..."

# Create the report file with different content based on analysis type
if [ "$ANALYSIS_TYPE" = "salary" ]; then
    # For salary analysis
    cat > $REPORT_FILE << EOL
# Comprehensive Spark Salary Analysis Report
**Generated on:** $(date)

## Executive Summary
This report presents a detailed analysis of salary data across various job titles, processed using Apache Spark technology. The analysis provides insights into salary distributions, trends, and comparative statistics across different job roles.

## Results from Spark Analysis

| Job Title | Min Salary | Max Salary | Avg Salary | Count |
|-----------|------------|------------|------------|-------|
EOL

    # Add top 20 jobs to report
    head -20 "$OUTPUT_DIR/part-00000" | while read -r line; do
        job_title=$(echo "$line" | cut -f1)
        stats=$(echo "$line" | cut -f2)
        min=$(echo "$stats" | cut -d',' -f1)
        max=$(echo "$stats" | cut -d',' -f2)
        avg=$(echo "$stats" | cut -d',' -f3)
        count=$(echo "$stats" | cut -d',' -f4)
        
        min_formatted=$(printf "$%'.2f" $min)
        max_formatted=$(printf "$%'.2f" $max)
        avg_formatted=$(printf "$%'.2f" $avg)
        
        echo "| $job_title | $min_formatted | $max_formatted | $avg_formatted | $count |" >> $REPORT_FILE
    done
    
elif [ "$ANALYSIS_TYPE" = "skills" ]; then
    # For skills analysis
    cat > $REPORT_FILE << EOL
# Comprehensive Spark Skills Analysis Report
**Generated on:** $(date)

## Executive Summary
This report presents a detailed analysis of technical skills mentioned in job descriptions, processed using Apache Spark technology. The analysis provides insights into the most in-demand skills in the job market.

## Top Skills from Spark Analysis

| Rank | Skill | Frequency |
|------|-------|-----------|
EOL

    # Add top 20 skills to report
    rank=1
    head -20 "$OUTPUT_DIR/part-00000" | while read -r line; do
        # Extract skill name and frequency from format like "(java,1542)"
        skill=$(echo "$line" | sed 's/^(//' | sed 's/,.*//')
        frequency=$(echo "$line" | sed 's/.*,//' | sed 's/)$//')
        
        echo "| $rank | $skill | $frequency |" >> $REPORT_FILE
        rank=$((rank+1))
    done
    
else
    echo "Error: Unknown analysis type '$ANALYSIS_TYPE'"
    echo "Please use 'salary' or 'skills'"
    exit 1
fi

# Add methodology section to the report
cat >> $REPORT_FILE << EOL

## Methodology
The data was processed using Apache Spark with the following steps:
1. **Data Collection**: Job listings were collected from a comprehensive dataset.
2. **Parsing**: Relevant information was extracted from job listings.
3. **Analysis**: Apache Spark was used to process and aggregate the data.

### Technical Implementation
- **Data Loading**: Input CSV data was loaded with automatic handling of quoted fields and commas.
- **Transformation**: RDDs were used to transform and process the data.
- **Reduction**: reduceByKey operation was used to aggregate results.

## System Information
- **Date:** $(date)
- **User:** $(whoami)
- **Platform:** $(uname -a)

## Note on Spark Integration
This analysis was performed using Apache Spark, which offers several advantages:
1. **Speed**: In-memory processing for faster computation
2. **Simplicity**: More concise code for complex analysis
3. **Scalability**: Ability to process large datasets efficiently
4. **Versatility**: Support for various data processing needs
EOL

echo "Report generation complete!"
echo "Report saved to $REPORT_FILE"
echo "============================================================="
