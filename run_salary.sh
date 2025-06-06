#!/bin/bash
# -------------------------------------------------------
# Salary Analysis - Truly Local Run Script 
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "   RUNNING SALARY ANALYZER MAPREDUCE JOB (TRULY LOCAL MODE)  "
echo "============================================================="
echo "Date: $(date)"
echo

# Check for correct number of arguments
if [ $# -ne 2 ]; then
    echo "Usage: ./run_truly_local.sh <input_path> <output_path>"
    echo "Example: ./run_truly_local.sh input/jobs.csv output/salary_analysis"
    exit 1
fi

# Set paths
INPUT_PATH=$1
OUTPUT_PATH=$2

# Set Hadoop and Java environment
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.16.jdk/Contents/Home
export HADOOP_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/hadoop
export HADOOP_CLASSPATH=./salary-analyzer.jar:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*

# Remove output directory if it exists
echo "Removing existing output directory if it exists..."
rm -rf $OUTPUT_PATH

# Create a small subset of the input file for testing
echo "Creating a test subset of the input data..."
TEST_FILE="input/mini_test.csv"
head -5 $INPUT_PATH > $TEST_FILE

# Run the MapReduce job using Java directly with local file system only
echo "Running Salary Analyzer job in truly local mode (Java only)..."
# Don't create output directory - MapReduce job will do this

# Run the Java application directly
java -cp $HADOOP_CLASSPATH \
  -Dmapreduce.framework.name=local \
  -Dfs.defaultFS=file:/// \
  -Djava.library.path=$HADOOP_HOME/lib/native \
  SalaryAnalyzer $TEST_FILE $OUTPUT_PATH

# Check if job completed successfully
if [ $? -eq 0 ]; then
    echo "Job completed successfully!"
    echo "Results are available at: $OUTPUT_PATH"
    echo
    echo "Sample results:"
    if [ -f "$OUTPUT_PATH/part-r-00000" ]; then
        cat $OUTPUT_PATH/part-r-00000
    else
        echo "No results found in the expected output path. Check job execution logs."
        ls -la $OUTPUT_PATH
    fi
else
    echo "Job failed! Check error messages above."
fi

echo "============================================================="
