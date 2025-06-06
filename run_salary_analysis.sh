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
    echo "Usage: ./run_salary_analysis.sh <input_path> <output_path>"
    echo "Example: ./run_salary_analysis.sh input/job_descriptions.csv output/salary_analysis"
    exit 1
fi

# Set paths
INPUT_PATH=$1
OUTPUT_PATH=$2

# Set Java and Hadoop environment
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@11/11.0.27/libexec/openjdk.jdk/Contents/Home
export HADOOP_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/hadoop
export HADOOP_CLASSPATH=./salary-analyzer.jar:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*

# Set local mode configuration
export HADOOP_CONF_DIR=./conf
mkdir -p $HADOOP_CONF_DIR
cat > $HADOOP_CONF_DIR/core-site.xml << EOF
<?xml version="1.0"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>file:///</value>
  </property>
</configuration>
EOF

cat > $HADOOP_CONF_DIR/mapred-site.xml << EOF
<?xml version="1.0"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>local</value>
  </property>
</configuration>
EOF

# Remove output directory if it exists
echo "Removing existing output directory if it exists..."
rm -rf $OUTPUT_PATH

# Run the MapReduce job in local mode
echo "Running Salary Analyzer job on full dataset..."
$HADOOP_HOME/bin/hadoop --config $HADOOP_CONF_DIR jar salary-analyzer.jar SalaryAnalyzer $INPUT_PATH $OUTPUT_PATH

# Check if job completed successfully
if [ $? -eq 0 ]; then
    echo "Job completed successfully!"
    echo "Results are available at: $OUTPUT_PATH"
    echo
    echo "Sample results (first 10 entries):"
    if [ -f "$OUTPUT_PATH/part-r-00000" ]; then
        head -10 $OUTPUT_PATH/part-r-00000
        
        # Count total number of unique job titles analyzed
        TOTAL_JOBS=$(wc -l < $OUTPUT_PATH/part-r-00000)
        echo
        echo "Total unique job titles analyzed: $TOTAL_JOBS"
        
        # Find job titles with highest and lowest average salaries
        echo
        echo "Top 5 highest paying job titles:"
        sort -t$'\t' -k2 -nr $OUTPUT_PATH/part-r-00000 | head -5
        
        echo
        echo "5 lowest paying job titles:"
        sort -t$'\t' -k2 -n $OUTPUT_PATH/part-r-00000 | head -5
    else
        echo "No results found in the expected output path. Check job execution logs."
    fi
else
    echo "Job failed! Check error messages above."
fi

echo "============================================================="