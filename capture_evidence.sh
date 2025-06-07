#!/bin/bash
# -------------------------------------------------------
# Technical Skills Analysis - Capture Screenshots
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 5, 2025
# -------------------------------------------------------
# This script captures screenshots of Hadoop execution for documentation

echo "============================================================="
echo "       CAPTURING EVIDENCE FOR TECHNICAL SKILLS ANALYZER      "
echo "============================================================="
echo "Date: $(date)"
echo

mkdir -p screenshots

echo "Capturing Hadoop version information..."
hadoop version > screenshots/hadoop_version.txt

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "Capturing project directory structure..."
ls -la > screenshots/directory_structure_${TIMESTAMP}.txt
find . -type f -not -path "*/\.*" | sort > screenshots/file_list_${TIMESTAMP}.txt

echo "Capturing job output..."
if [ -d "output/skills_analysis_local" ]; then
    head -n 50 output/skills_analysis_local/part-r-00000 > screenshots/output_sample_${TIMESTAMP}.txt
    echo "... (output truncated)" >> screenshots/output_sample_${TIMESTAMP}.txt
    
    echo "Total skills found: $(wc -l < output/skills_analysis_local/part-r-00000)" > screenshots/output_stats_${TIMESTAMP}.txt
    echo "Top 20 skills:" >> screenshots/output_stats_${TIMESTAMP}.txt
    sort -k2 -nr output/skills_analysis_local/part-r-00000 | head -20 >> screenshots/output_stats_${TIMESTAMP}.txt
else
    echo "Output directory not found. Run the job first." > screenshots/output_stats_${TIMESTAMP}.txt
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Taking screenshot of terminal..."
    screencapture -w screenshots/terminal_execution_${TIMESTAMP}.png
    echo "Screenshot saved to screenshots/terminal_execution_${TIMESTAMP}.png"
fi

echo "============================================================="
echo "Evidence collection completed!"
echo "Files saved in the screenshots directory"
echo "============================================================="

ls -la screenshots/
