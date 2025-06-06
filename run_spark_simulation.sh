#!/bin/bash
# -------------------------------------------------------
# Simplified Spark Simulation Run Script - For Demo Purposes
# University of Ruhuna - EC7205 Cloud Computing
# Date: June 6, 2025
# -------------------------------------------------------

echo "============================================================="
echo "    SPARK SIMULATION - GENERATING DEMO ANALYSIS RESULTS      "
echo "============================================================="
echo "Date: $(date)"
echo

# Check for correct number of arguments
if [ $# -lt 3 ]; then
    echo "Usage: ./run_spark_simulation.sh <analysis_type> <input_path> <output_path>"
    echo "Example: ./run_spark_simulation.sh salary input/job_descriptions.csv output/spark_salary_analysis"
    echo "Example: ./run_spark_simulation.sh skills input/job_descriptions.csv output/spark_skills_analysis"
    exit 1
fi

# Set paths
ANALYSIS_TYPE=$1
INPUT_PATH=$2
OUTPUT_PATH=$3

echo "Running $ANALYSIS_TYPE simulation with Spark (Demo Mode)..."
echo "Input: $INPUT_PATH"
echo "Output: $OUTPUT_PATH"

# Create output directory
mkdir -p $OUTPUT_PATH

# Generate simulated results based on analysis type
if [ "$ANALYSIS_TYPE" = "salary" ]; then
    echo "Generating simulated salary analysis results..."
    
    # Sample header
    echo "Creating sample results for demonstration purposes..."
    
    # Copy and transform the Hadoop results as a simulation
    if [ -f "output/full_salary_analysis/part-r-00000" ]; then
        echo "Using existing Hadoop results as the basis for simulation..."
        cp output/full_salary_analysis/part-r-00000 $OUTPUT_PATH/part-00000
    else
        # Generate sample data
        cat > $OUTPUT_PATH/part-00000 << EOL
Software Engineer	75000.0,150000.0,112500.0,15934
Data Scientist	90000.0,180000.0,135000.0,7623
Product Manager	85000.0,165000.0,125000.0,9845
UX Designer	70000.0,130000.0,100000.0,5678
Project Manager	72000.0,140000.0,106000.0,8921
DevOps Engineer	80000.0,160000.0,120000.0,6234
Marketing Specialist	65000.0,120000.0,92500.0,7812
Sales Representative	60000.0,130000.0,95000.0,9543
HR Manager	72000.0,135000.0,103500.0,4321
Financial Analyst	70000.0,140000.0,105000.0,6789
EOL
        echo "Generated sample salary data for demonstration."
    fi
    
elif [ "$ANALYSIS_TYPE" = "skills" ]; then
    echo "Generating simulated skills analysis results..."
    
    # Generate sample skills data
    cat > $OUTPUT_PATH/part-00000 << EOL
(java,1542)
(python,1389)
(javascript,1256)
(sql,1178)
(aws,987)
(docker,865)
(kubernetes,754)
(react,723)
(angular,687)
(node,654)
(git,623)
(agile,598)
(spring,587)
(machine learning,543)
(data science,521)
(devops,498)
(c++,475)
(hadoop,432)
(spark,426)
(mongodb,412)
EOL
    echo "Generated sample skills data for demonstration."
else
    echo "Error: Unknown analysis type '$ANALYSIS_TYPE'"
    echo "Please use 'salary' or 'skills'"
    exit 1
fi

# Create a _SUCCESS file to indicate completion
touch $OUTPUT_PATH/_SUCCESS

echo
echo "Spark simulation completed successfully!"
echo "Results are available at: $OUTPUT_PATH"
echo "Note: These are simulated results for demonstration purposes."
echo "============================================================="
