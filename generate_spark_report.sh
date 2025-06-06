#!/bin/bash
# -------------------------------------------------------
# Spark Analysis - Comprehensive Report Generator
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "    GENERATING COMPREHENSIVE SPARK ANALYSIS REPORT           "
echo "============================================================="
echo "Date: $(date)"
echo

# Check if report type and output directory were provided
if [ $# -lt 2 ]; then
    echo "Usage: ./generate_spark_report.sh <analysis_type> <output_directory>"
    echo "Example: ./generate_spark_report.sh salary output/spark_salary_analysis"
    echo "Example: ./generate_spark_report.sh skills output/spark_skills_analysis"
    exit 1
fi

ANALYSIS_TYPE=$1
OUTPUT_DIR=$2

# Set the report file name based on analysis type
if [ "$ANALYSIS_TYPE" = "salary" ]; then
    REPORT_FILE="SPARK_SALARY_ANALYSIS_REPORT.md"
elif [ "$ANALYSIS_TYPE" = "skills" ]; then
    REPORT_FILE="SPARK_SKILLS_ANALYSIS_REPORT.md"
else
    echo "Error: Unknown analysis type '$ANALYSIS_TYPE'"
    echo "Please use 'salary' or 'skills'"
    exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' not found."
    exit 1
fi

# Check if part-00000 file exists in the output directory
if [ ! -f "$OUTPUT_DIR/part-00000" ]; then
    echo "Error: Results file '$OUTPUT_DIR/part-00000' not found."
    echo "Make sure the Spark job completed successfully."
    exit 1
fi

echo "Analyzing $ANALYSIS_TYPE data in $OUTPUT_DIR..."

# Create temporary files for analysis
TEMP_DIR="temp_spark_analysis"
mkdir -p $TEMP_DIR

# Create the report file with different content based on analysis type
if [ "$ANALYSIS_TYPE" = "salary" ]; then
    # For salary analysis
    
    # Sort by average salary (descending)
    sort -t',' -k3 -nr "$OUTPUT_DIR/part-00000" > "$TEMP_DIR/sorted_by_salary.txt"
    
    # Sort by job count (descending)
    sort -t',' -k4 -nr "$OUTPUT_DIR/part-00000" > "$TEMP_DIR/sorted_by_count.txt"
    
    # Create the report file
    cat > $REPORT_FILE << EOL
# Comprehensive Spark Salary Analysis Report
**Generated on:** $(date)

## Executive Summary
This report presents a detailed analysis of salary data across various job titles, processed using Apache Spark technology. The analysis provides insights into salary distributions, trends, and comparative statistics across different job roles.

## Key Findings
EOL

    # Calculate overall statistics
    echo "Calculating statistics..."

    # Total jobs analyzed
    total_jobs=$(awk -F',' '{sum += $4} END {print sum}' "$OUTPUT_DIR/part-00000")

    # Total job titles
    total_titles=$(wc -l < "$OUTPUT_DIR/part-00000")

    # Overall average salary
    avg_salary=$(awk -F',' '{sum += $3 * $4; count += $4} END {printf "%.2f", sum/count}' "$OUTPUT_DIR/part-00000")
    avg_formatted=$(printf "$%'.2f" $avg_salary)

    # Minimum and maximum salaries overall
    min_salary=$(awk -F',' '{if(NR==1 || $1 < min) min=$1} END {print min}' "$OUTPUT_DIR/part-00000")
    min_salary_formatted=$(printf "$%'.2f" $min_salary)

    max_salary=$(awk -F',' '{if(NR==1 || $2 > max) max=$2} END {print max}' "$OUTPUT_DIR/part-00000")
    max_salary_formatted=$(printf "$%'.2f" $max_salary)

    # Process data for the report
    awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-00000" | sort -t$'\t' -k2 -nr | head -5 > "$TEMP_DIR/top_5_jobs.txt"
    awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-00000" | sort -t$'\t' -k2 -n | head -5 > "$TEMP_DIR/bottom_5_jobs.txt"
    awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-00000" | sort -t$'\t' -k3 -nr | head -5 > "$TEMP_DIR/most_common_jobs.txt"
    
    # Read the files
    top_5_jobs=$(cat "$TEMP_DIR/top_5_jobs.txt")
    bottom_5_jobs=$(cat "$TEMP_DIR/bottom_5_jobs.txt")
    most_common_jobs=$(cat "$TEMP_DIR/most_common_jobs.txt")
    
    # Add key findings to report
    cat >> $REPORT_FILE << EOL
- **Total Job Listings Analyzed:** $total_jobs
- **Unique Job Titles:** $total_titles
- **Overall Average Salary:** $avg_formatted
- **Salary Range:** $min_salary_formatted to $max_salary_formatted

## Top Paying Jobs

| Rank | Job Title | Average Salary | Count |
|------|-----------|---------------|-------|
EOL

    # Add top 5 paying jobs to report
    rank=1
    echo "$top_5_jobs" | while IFS=$'\t' read -r title avg count; do
        avg_formatted=$(printf "$%'.2f" $avg)
        echo "| $rank | $title | $avg_formatted | $count |" >> $REPORT_FILE
        rank=$((rank+1))
    done
    
    # Add more report sections...
    cat >> $REPORT_FILE << EOL

## Methodology
The salary data was processed using Apache Spark with the following steps:
1. **Data Collection**: Job listings were collected from a comprehensive dataset.
2. **Parsing**: Salary ranges were extracted from job listings using regular expression pattern matching.
3. **Calculation**: For each job listing, the average salary was calculated from the minimum and maximum values.
4. **Aggregation**: Statistics were aggregated by job title to find minimums, maximums, and weighted averages.

### Technical Implementation
- **Data Loading**: Input CSV data was loaded with automatic handling of quoted fields and commas.
- **Transformation**: RDDs were used to transform the data, extract salary information, and compute statistics.
- **Reduction**: reduceByKey operation was used to combine salary information for each job title.

## System Information
- **Date:** $(date)
- **Spark Version:** $(spark-submit --version 2>&1 | grep version | head -1)
- **User:** $(whoami)
- **Platform:** $(uname -a)

## Performance Comparison with Hadoop MapReduce
The Spark implementation offers several benefits compared to the Hadoop MapReduce implementation:
1. **Speed**: In-memory processing allows for faster computation
2. **Simplicity**: More concise code for the same functionality
3. **Interactive**: Support for interactive analysis and ad-hoc queries
4. **Unified Engine**: Same engine for batch, streaming, and machine learning tasks
EOL

elif [ "$ANALYSIS_TYPE" = "skills" ]; then
    # For skills analysis
    
    # Sort by frequency (descending)
    sort -t',' -k2 -nr "$OUTPUT_DIR/part-00000" > "$TEMP_DIR/sorted_by_frequency.txt"
    
    # Create the report file
    cat > $REPORT_FILE << EOL
# Comprehensive Spark Skills Analysis Report
**Generated on:** $(date)

## Executive Summary
This report presents a detailed analysis of technical skills mentioned in job descriptions, processed using Apache Spark technology. The analysis provides insights into the most in-demand skills in the job market.

## Key Findings
EOL

    # Calculate overall statistics
    echo "Calculating statistics..."

    # Total skills analyzed
    total_skills=$(wc -l < "$OUTPUT_DIR/part-00000")

    # Total mentions
    total_mentions=$(awk -F',' '{sum += $2} END {print sum}' "$OUTPUT_DIR/part-00000")

    # Add key findings to report
    cat >> $REPORT_FILE << EOL
- **Total Unique Skills Analyzed:** $total_skills
- **Total Skill Mentions:** $total_mentions

## Top 20 In-Demand Skills

| Rank | Skill | Frequency | % of Total |
|------|-------|-----------|------------|
EOL

    # Add top 20 skills to report
    rank=1
    head -20 "$TEMP_DIR/sorted_by_frequency.txt" | while IFS=$'\t' read -r skill frequency; do
        skill=$(echo $skill | sed 's/^(//' | sed 's/,.*$//')
        freq=$(echo $frequency | sed 's/.*,//' | sed 's/)$//')
        percentage=$(echo "scale=2; $freq * 100 / $total_mentions" | bc)
        echo "| $rank | $skill | $freq | ${percentage}% |" >> $REPORT_FILE
        rank=$((rank+1))
    done

    # Add more report sections...
    cat >> $REPORT_FILE << EOL

## Methodology
The skills data was processed using Apache Spark with the following steps:
1. **Data Collection**: Job listings were collected from a comprehensive dataset.
2. **Text Extraction**: Job titles, descriptions and explicit skill lists were extracted.
3. **Skill Matching**: A dictionary of known technical skills was used to match against the text.
4. **Frequency Counting**: All skills were counted and aggregated.

### Technical Implementation
- **Data Loading**: Input CSV data was loaded with automatic handling of quoted fields and commas.
- **Transformation**: RDDs were used to transform the data, extract skills, and compute frequencies.
- **Filtering**: Low-frequency skills (fewer than 10 mentions) were filtered out to reduce noise.

## System Information
- **Date:** $(date)
- **Spark Version:** $(spark-submit --version 2>&1 | grep version | head -1)
- **User:** $(whoami)
- **Platform:** $(uname -a)

## Performance Comparison with Hadoop MapReduce
The Spark implementation offers several benefits compared to the Hadoop MapReduce implementation:
1. **Speed**: In-memory processing allows for faster computation
2. **Simplicity**: More concise code for the same functionality
3. **Interactive**: Support for interactive analysis and ad-hoc queries
4. **Unified Engine**: Same engine for batch, streaming, and machine learning tasks
EOL

else
    echo "Error: Unknown analysis type '$ANALYSIS_TYPE'"
    echo "Please use 'salary' or 'skills'"
    exit 1
fi

# Cleanup temporary files
rm -rf $TEMP_DIR

echo "Report generation complete!"
echo "Report saved to $REPORT_FILE"
echo "============================================================="
