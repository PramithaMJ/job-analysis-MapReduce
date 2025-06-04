#!/bin/bash
# filepath: /Users/pramithajayasooriya/Desktop/Hadoop/hadoop_project/generate_report.sh
# ----------------------------------------------------
# Generate Top Skills Report from MapReduce Output
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 5, 2025
# ----------------------------------------------------

OUTPUT_DIR="output/skills_analysis_local"
JOB_HISTORY="job_history.log"

echo "============================================================="
echo "              TECHNICAL SKILLS ANALYSIS REPORT                "
echo "============================================================="
echo "Date: $(date)"

# Extract dataset name and count from job history if available
if [ -f "$JOB_HISTORY" ]; then
    DATASET=$(grep "Input path:" "$JOB_HISTORY" | awk '{print $NF}' | xargs basename)
    RECORD_COUNT=$(grep "Map input records=" "$JOB_HISTORY" | awk -F'=' '{print $2}' | awk '{print $1}')
    
    echo "Dataset: $DATASET"
    echo "Records processed: $RECORD_COUNT"
else
    echo "Dataset: [Job history not available]"
    echo "Records processed: [Job history not available]"
fi

echo "============================================================="
echo "TOP 20 MOST DEMANDED SKILLS:"
echo "============================================================="

# Check if output directory exists
if [ -d "$OUTPUT_DIR" ]; then
    # Sort the output by frequency (descending) and display top 20
    cat $OUTPUT_DIR/part-r-* 2>/dev/null | sort -k2 -nr | head -20
else
    echo "Output directory not found. Please run the MapReduce job first."
fi

echo "============================================================="
echo "MapReduce Job Execution Statistics:"
echo "============================================================="

# Extract actual statistics from job history
if [ -f "$JOB_HISTORY" ]; then
    grep -E "Map input records=|Map output records=|Combine input records=|Combine output records=|Reduce output records=" "$JOB_HISTORY" | \
    sed 's/^/- /' | sed 's/=/ = /'
else
    echo "Job history file not found. Run the MapReduce job with logging enabled."
fi
echo "============================================================="