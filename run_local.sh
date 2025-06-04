#!/bin/bash
# -------------------------------------------------------
# Technical Skills Analysis - MapReduce Local Run Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 5, 2025
# -------------------------------------------------------
# This script runs the Technical Skills Analyzer MapReduce job in local mode
# It processes job descriptions to extract and count skills mentioned

# Set Java and Hadoop environment variables
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.16.jdk/Contents/Home
export HADOOP_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export CLASSPATH=$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*

# Set Hadoop to run in local mode (not on a cluster)
export HADOOP_OPTS="-Dfs.defaultFS=file:/// -Dmapreduce.framework.name=local -Dyarn.resourcemanager.hostname=localhost"

# Run the MapReduce job with input CSV and output directory
# Arguments:
# 1. skills-analyzer.jar: The compiled JAR containing our MapReduce code
# 2. SkillsAnalyzer: The main class that defines our MapReduce job
# 3. input/job_descriptions_sample.csv: The input dataset
# 4. output/skills_analysis_local: The directory where output will be saved
echo "Starting SkillsAnalyzer MapReduce job at $(date)"
echo "Input: input/job_descriptions.csv"
echo "Output: output/skills_analysis_local"

# Remove previous output directory if it exists
if [ -d "output/skills_analysis_local" ]; then
    rm -rf output/skills_analysis_local
    echo "Removed previous output directory"
fi

# Run the MapReduce job and log output
java -cp skills-analyzer.jar:$CLASSPATH SkillsAnalyzer input/job_descriptions.csv output/skills_analysis_local | tee -a execution_log.txt

# Check if the job completed successfully
if [ $? -eq 0 ]; then
    echo "Job completed successfully at $(date)" | tee -a execution_log.txt
    echo "Output saved to output/skills_analysis_local" | tee -a execution_log.txt
else
    echo "Job failed at $(date)" | tee -a execution_log.txt
fi
