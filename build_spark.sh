#!/bin/bash
# -------------------------------------------------------
# Spark Analysis - Build Script
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------
# This script compiles the Spark Java classes and packages them into a JAR

echo "============================================================="
echo "           BUILDING SPARK ANALYZER JOBS                      "
echo "============================================================="
echo "Date: $(date)"
echo

# Set Java and Spark environment variables
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.16.jdk/Contents/Home
export SPARK_HOME=/Users/pramithajayasooriya/Desktop/Hadoop/spark

# Clean previous build
echo "Cleaning previous spark build..."
rm -rf spark_classes
mkdir -p spark_classes

# Check if Spark is installed
SKIP_SPARK=false
if [ ! -d "$SPARK_HOME" ]; then
    echo "Warning: Spark not found at $SPARK_HOME"
    echo "Attempting to create a simulation build with standard Java libraries..."
    SKIP_SPARK=true
    
    # Create a minimal Spark simulation classpath
    SPARK_CLASSPATH="."
else
    # Create classpath with Spark JARs
    SPARK_CLASSPATH=$SPARK_HOME/jars/*
fi

# Compile Java files with Java 11 compatibility
echo "Compiling Spark Java source files..."
javac -source 11 -target 11 -cp $SPARK_CLASSPATH -d spark_classes src/SparkSalaryAnalyzer.java src/SparkSkillsAnalyzer.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    
    # Create JAR file
    echo "Creating JAR file..."
    jar -cvf spark-analyzer.jar -C spark_classes .
    
    echo "============================================================="
    echo "Build completed successfully!"
    echo "JAR file created: spark-analyzer.jar"
    echo "============================================================="
else
    echo "============================================================="
    echo "ERROR: Compilation failed!"
    echo "============================================================="
    exit 1
fi
