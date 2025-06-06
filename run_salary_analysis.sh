#!/bin/bash
# -------------------------------------------------------
# Salary Analysis - End-to-End Workflow Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "       RUNNING COMPLETE SALARY ANALYSIS WORKFLOW             "
echo "============================================================="
echo "Date: $(date)"
echo

# Define output directories
OUTPUT_DIR="output/salary_analysis_$(date +%Y%m%d_%H%M%S)"
SCREENSHOTS_DIR="screenshots/salary_analysis_$(date +%Y%m%d_%H%M%S)"

# Create screenshots directory if it doesn't exist
mkdir -p "$SCREENSHOTS_DIR"

echo "Step 1: Building the MapReduce job..."
./build_salary.sh 2>&1 | tee "$SCREENSHOTS_DIR/build_log.txt"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error: Build failed. Check the build log for details."
    exit 1
fi

echo
echo "Step 2: Running the MapReduce job in local mode..."

if [ -n "$1" ]; then
    INPUT_FILE="$1"
    echo "Using provided input file: $INPUT_FILE"
else
    # Use default input file
    INPUT_FILE="input/job_descriptions.csv"
    echo "Using default input file: $INPUT_FILE"
fi

# First create a small test sample for verification
TEST_OUTPUT_DIR="${OUTPUT_DIR}_test"
echo "Running test job with sample data..."
head -50 "$INPUT_FILE" > "input/sample_data.csv"
./run_truly_local.sh "input/sample_data.csv" "$TEST_OUTPUT_DIR" 2>&1 | tee "$SCREENSHOTS_DIR/test_job_log.txt"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error: Test job failed. Check the log for details."
    exit 1
fi

echo
echo "Test job completed successfully. Running full job..."
./run_truly_local.sh "$INPUT_FILE" "$OUTPUT_DIR" 2>&1 | tee "$SCREENSHOTS_DIR/job_log.txt"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error: Full job failed. Check the log for details."
    exit 1
fi

echo
echo "Step 3: Generating salary analysis report..."
./generate_salary_report.sh "$OUTPUT_DIR" 2>&1 | tee "$SCREENSHOTS_DIR/report_log.txt"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error: Report generation failed."
    exit 1
fi

# Capture system and output information for documentation
echo
echo "Step 4: Capturing analysis evidence..."

# Save Hadoop version
hadoop version > "$SCREENSHOTS_DIR/hadoop_version.txt"

# Save directory structure
ls -la > "$SCREENSHOTS_DIR/file_list.txt"
find . -type d | sort > "$SCREENSHOTS_DIR/directory_structure.txt"

# Save sample output
head -20 "$OUTPUT_DIR/part-r-00000" > "$SCREENSHOTS_DIR/output_sample.txt"

# Generate statistics about the output
echo "Job Title Count: $(wc -l < "$OUTPUT_DIR/part-r-00000")" > "$SCREENSHOTS_DIR/output_stats.txt"
echo "Highest Salary: $(sort -t$'\t' -k2.9 -nr "$OUTPUT_DIR/part-r-00000" | head -1)" >> "$SCREENSHOTS_DIR/output_stats.txt"
echo "Lowest Salary: $(sort -t$'\t' -k2.9 -n "$OUTPUT_DIR/part-r-00000" | head -1)" >> "$SCREENSHOTS_DIR/output_stats.txt"

# Copy the report to screenshots directory for archiving
cp SALARY_ANALYSIS_REPORT.md "$SCREENSHOTS_DIR/"

echo
echo "============================================================="
echo "          SALARY ANALYSIS WORKFLOW COMPLETED                 "
echo "============================================================="
echo "Output data: $OUTPUT_DIR"
echo "Analysis report: SALARY_ANALYSIS_REPORT.md"
echo "Evidence files: $SCREENSHOTS_DIR"
echo "============================================================="
