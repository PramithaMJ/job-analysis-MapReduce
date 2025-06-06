#!/bin/bash
# -------------------------------------------------------
# Enhanced Salary Analysis - Comprehensive Report Generator
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "      GENERATING COMPREHENSIVE SALARY ANALYSIS REPORT        "
echo "============================================================="
echo "Date: $(date)"
echo

# Check if output directory was provided, otherwise use default
OUTPUT_DIR="${1:-output/full_salary_analysis}"
REPORT_FILE="COMPREHENSIVE_SALARY_REPORT.md"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' not found."
    echo "Usage: ./generate_comprehensive_report.sh [output_directory]"
    exit 1
fi

# Check if part-r-00000 file exists in the output directory
if [ ! -f "$OUTPUT_DIR/part-r-00000" ]; then
    echo "Error: Results file '$OUTPUT_DIR/part-r-00000' not found."
    echo "Make sure the MapReduce job completed successfully."
    exit 1
fi

echo "Analyzing salary data in $OUTPUT_DIR..."

# Create temporary files for analysis
TEMP_DIR="temp_analysis"
mkdir -p $TEMP_DIR

# Sort by average salary (descending)
sort -t$'\t' -k2.9 -nr "$OUTPUT_DIR/part-r-00000" > "$TEMP_DIR/sorted_by_salary.txt"

# Sort by job count (descending)
sort -t$'\t' -k2 -t, -k4 -nr "$OUTPUT_DIR/part-r-00000" > "$TEMP_DIR/sorted_by_count.txt"

# Create the report file
cat > $REPORT_FILE << EOL
# Comprehensive Salary Analysis Report
**Generated on:** $(date)

## Executive Summary
This report presents a detailed analysis of salary data across various job titles, processed using Hadoop MapReduce technology. The analysis provides insights into salary distributions, trends, and comparative statistics across different job roles.

## Key Findings
EOL

# Calculate overall statistics
echo "Calculating statistics..."

# Total jobs analyzed
total_jobs=$(awk -F',' '{sum += $4} END {print sum}' "$OUTPUT_DIR/part-r-00000")

# Total job titles
total_titles=$(wc -l < "$OUTPUT_DIR/part-r-00000")

# Overall average salary
avg_salary=$(awk -F',' '{sum += $3 * $4; count += $4} END {printf "%.2f", sum/count}' "$OUTPUT_DIR/part-r-00000")
avg_formatted=$(printf "$%'.2f" $avg_salary)

# Minimum and maximum salaries overall
min_salary=$(awk -F',' '{if(NR==1 || $1 < min) min=$1} END {print min}' "$OUTPUT_DIR/part-r-00000")
min_salary_formatted=$(printf "$%'.2f" $min_salary)

max_salary=$(awk -F',' '{if(NR==1 || $2 > max) max=$2} END {print max}' "$OUTPUT_DIR/part-r-00000")
max_salary_formatted=$(printf "$%'.2f" $max_salary)

# Find top and bottom 5 paying jobs by average salary
awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-r-00000" | sort -t$'\t' -k2 -nr | head -5 > "$TEMP_DIR/top_5_jobs.txt"
awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-r-00000" | sort -t$'\t' -k2 -n | head -5 > "$TEMP_DIR/bottom_5_jobs.txt"

# Find most and least common jobs by count
awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-r-00000" | sort -t$'\t' -k3 -nr | head -5 > "$TEMP_DIR/most_common_jobs.txt"
awk -F'\t' '{split($2,a,","); print $1 "\t" a[3] "\t" a[4]}' "$OUTPUT_DIR/part-r-00000" | sort -t$'\t' -k3 -n | head -5 > "$TEMP_DIR/least_common_jobs.txt"

# Read the files
top_5_jobs=$(cat "$TEMP_DIR/top_5_jobs.txt")
bottom_5_jobs=$(cat "$TEMP_DIR/bottom_5_jobs.txt")
most_common_jobs=$(cat "$TEMP_DIR/most_common_jobs.txt")
least_common_jobs=$(cat "$TEMP_DIR/least_common_jobs.txt")

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

cat >> $REPORT_FILE << EOL

## Lowest Paying Jobs

| Rank | Job Title | Average Salary | Count |
|------|-----------|---------------|-------|
EOL

# Add bottom 5 paying jobs to report
rank=1
echo "$bottom_5_jobs" | while IFS=$'\t' read -r title avg count; do
    avg_formatted=$(printf "$%'.2f" $avg)
    echo "| $rank | $title | $avg_formatted | $count |" >> $REPORT_FILE
    rank=$((rank+1))
done

cat >> $REPORT_FILE << EOL

## Most Common Job Titles

| Rank | Job Title | Count | Average Salary |
|------|-----------|-------|---------------|
EOL

# Add most common jobs to report
rank=1
echo "$most_common_jobs" | while IFS=$'\t' read -r title avg count; do
    avg_formatted=$(printf "$%'.2f" $avg)
    echo "| $rank | $title | $count | $avg_formatted |" >> $REPORT_FILE
    rank=$((rank+1))
done

cat >> $REPORT_FILE << EOL

## Complete Salary Statistics by Job Title

Below is a comprehensive list of all job titles analyzed, including their salary statistics:

| Job Title | Minimum Salary | Maximum Salary | Average Salary | Count |
|-----------|---------------|---------------|---------------|-------|
EOL

# Add all jobs to report (first 100 for readability)
head -100 "$OUTPUT_DIR/part-r-00000" | while IFS=$'\t' read -r title stats; do
    IFS=',' read -r min max avg count <<< "$stats"
    min_formatted=$(printf "$%'.2f" $min)
    max_formatted=$(printf "$%'.2f" $max)
    avg_formatted=$(printf "$%'.2f" $avg)
    echo "| $title | $min_formatted | $max_formatted | $avg_formatted | $count |" >> $REPORT_FILE
done

# Add note if there are more than 100 job titles
if [ "$total_titles" -gt 100 ]; then
    echo "\n*Note: Table truncated to 100 entries out of $total_titles total job titles.*" >> $REPORT_FILE
fi

cat >> $REPORT_FILE << EOL

## Methodology
The salary data was processed using a Hadoop MapReduce job with the following steps:
1. **Data Collection**: Job listings were collected from a comprehensive dataset.
2. **Parsing**: Salary ranges were extracted from job listings using regular expression pattern matching.
3. **Calculation**: For each job listing, the average salary was calculated from the minimum and maximum values.
4. **Aggregation**: Statistics were aggregated by job title to find minimums, maximums, and weighted averages.

### Technical Implementation
- **Mapper Phase**: Extracted job titles and salary information, emitting (jobTitle, salaryInfo) pairs.
- **Reducer Phase**: Combined all salary information for each job title to calculate aggregate statistics.

## Analysis Insights
- **Salary Distribution**: The average salary across all analyzed job titles is $avg_formatted.
- **Salary Range**: Most job titles have salaries ranging from $min_salary_formatted to $max_salary_formatted.
- **High-Paying Roles**: Top paying jobs tend to be in specialized fields or management roles.

## Recommendations for Further Analysis
1. **Geographic Analysis**: Compare salaries across different regions/countries.
2. **Time-Series Analysis**: Track salary trends over time to identify growing or declining fields.
3. **Industry Segmentation**: Break down salary data by industry sector.
4. **Skill Premium Analysis**: Identify which skills correlate with higher salaries.

## System Information
- **Date:** $(date)
- **Hadoop Version:** $(hadoop version | head -1)
- **User:** $(whoami)
- **Platform:** $(uname -a)
EOL

# Cleanup temporary files
rm -rf $TEMP_DIR

echo "Report generation complete!"
echo "Report saved to $REPORT_FILE"
echo "============================================================="
