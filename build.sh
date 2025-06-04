#!/bin/bash
# -------------------------------------------------------
# Technical Skills Analysis - Build Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 5, 2025
# -------------------------------------------------------
# This script compiles the MapReduce Java classes and packages them into a JAR

echo "============================================================="
echo "      BUILDING TECHNICAL SKILLS ANALYZER MAPREDUCE JOB       "
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

# Compile Java files
echo "Compiling Java source files..."
javac -cp $HADOOP_CLASSPATH -d classes src/*.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    
    # Create JAR file
    echo "Creating JAR file..."
    jar -cvf skills-analyzer.jar -C classes .
    
    echo "============================================================="
    echo "Build completed successfully!"
    echo "JAR file created: skills-analyzer.jar"
    echo "============================================================="
else
    echo "============================================================="
    echo "ERROR: Compilation failed!"
    echo "============================================================="
    exit 1
fi
