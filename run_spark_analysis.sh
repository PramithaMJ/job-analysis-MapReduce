#!/bin/bash
# -------------------------------------------------------
# Spark Salary Analysis - Run Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "        RUNNING SPARK SALARY ANALYZER JOB                    "
echo "============================================================="
echo "Date: $(date)"
echo

# Check for correct number of arguments
if [ $# -lt 3 ]; then
    echo "Usage: ./run_spark_analysis.sh <analysis_type> <input_path> <output_path>"
    echo "Example: ./run_spark_analysis.sh salary input/job_descriptions.csv output/spark_salary_analysis"
    echo "Example: ./run_spark_analysis.sh skills input/job_descriptions.csv output/spark_skills_analysis"
    exit 1
fi

# Set paths
ANALYSIS_TYPE=$1
INPUT_PATH=$2
OUTPUT_PATH=$3

# Set Java and Spark environment
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@11/11.0.27/libexec/openjdk.jdk/Contents/Home
export SPARK_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/spark

# Check if Spark is installed
if [ ! -d "$SPARK_HOME" ]; then
    echo "Error: Spark not found at $SPARK_HOME"
    echo "Please install Spark or update the SPARK_HOME variable."
    exit 1
fi

# Specify main class based on analysis type
if [ "$ANALYSIS_TYPE" = "salary" ]; then
    MAIN_CLASS="src.SparkSalaryAnalyzer"
    echo "Running Spark Salary Analysis..."
elif [ "$ANALYSIS_TYPE" = "skills" ]; then
    MAIN_CLASS="src.SparkSkillsAnalyzer"
    echo "Running Spark Skills Analysis..."
else
    echo "Error: Unknown analysis type '$ANALYSIS_TYPE'"
    echo "Please use 'salary' or 'skills'"
    exit 1
fi

# Remove output directory if it exists
echo "Removing existing output directory if it exists..."
rm -rf $OUTPUT_PATH

# Run the Spark job
echo "Running $ANALYSIS_TYPE analysis on dataset..."
$SPARK_HOME/bin/spark-submit \
    --class $MAIN_CLASS \
    --master local[*] \
    --conf spark.driver.memory=2g \
    --conf spark.executor.memory=2g \
    spark-analyzer.jar \
    $INPUT_PATH $OUTPUT_PATH

# Check if job completed successfully
if [ $? -eq 0 ]; then
    echo "Job completed successfully!"
    echo "Results are available at: $OUTPUT_PATH"
    echo
    echo "Sample results (first entries):"
    if [ -f "$OUTPUT_PATH/part-00000" ]; then
        head -10 $OUTPUT_PATH/part-00000
        
        # Count total number of results
        TOTAL=$(cat $OUTPUT_PATH/part-* | wc -l | xargs)
        echo
        echo "Total results: $TOTAL"
        
    else
        echo "No results found in the expected output path. Check job execution logs."
    fi
else
    echo "Job failed! Check error messages above."
fi

echo "============================================================="
