#!/bin/bash
# -------------------------------------------------------
# Salary Analysis - Build Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------
# This script compiles the MapReduce Java classes and packages them into a JAR

echo "============================================================="
echo "           BUILDING SALARY ANALYZER MAPREDUCE JOB            "
echo "============================================================="
echo "Date: $(date)"
echo

# Set Java and Hadoop environment variables
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.16.jdk/Contents/Home
export HADOOP_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/hadoop
export HADOOP_CLASSPATH=$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*

# Clean previous build
echo "Cleaning previous build..."
rm -rf classes
mkdir -p classes

# Compile Java files with Java 11 compatibility
echo "Compiling Java source files..."
javac -source 11 -target 11 -cp $HADOOP_CLASSPATH -d classes src/SalaryMapper.java src/SalaryReducer.java src/SalaryAnalyzer.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    
    # Create JAR file
    echo "Creating JAR file..."
    jar -cvf salary-analyzer.jar -C classes .
    
    echo "============================================================="
    echo "Build completed successfully!"
    echo "JAR file created: salary-analyzer.jar"
    echo "============================================================="
else
    echo "============================================================="
    echo "ERROR: Compilation failed!"
    echo "============================================================="
    exit 1
fi