# Hadoop & Spark Job Market Analysis - Project Summary

## EC7205 Cloud Computing - Assignment 1

### University of Ruhuna, Faculty of Engineering

## Team Members

- Pramitha Jayasooriya
- Tharindu Jayawardhana
- Chandula Jayathilake

## Project Overview

This project implements both Hadoop MapReduce and Apache Spark solutions to analyze job descriptions data with two main focus areas:

1. **Technical Skills Analysis**: Identifies the most in-demand technical skills in the current job market by processing job posting information to extract, count, and rank skills mentioned across job titles, descriptions, and required skills sections.
2. **Salary Analysis**: Analyzes salary information across different job titles to identify trends, high-paying roles, and salary distributions across the job market.

## 1. Dataset Selection

### Dataset Details

- **Name**: Job Descriptions Dataset
- **Source**: [Source information - e.g., Kaggle, etc.]
- **Size**: ~1.7GB with over 100,000 records
- **Format**: CSV with multiple columns
- **Key Columns Used**:
  - Job Title (column 14)
  - Job Description (column 17)
  - Skills (column 19)

### Dataset Appropriateness

The dataset is well-suited for MapReduce processing because:

- It contains unstructured text that requires extraction and analysis
- The dataset size is substantial, demonstrating the need for distributed processing
- The extraction of skills from job descriptions is a real-world data analysis task
- The results provide actionable insights for job seekers and educational institutions

## 2. MapReduce Implementation

### Task Description

Our MapReduce job identifies and counts in-demand technical skills by:

1. Parsing CSV job posting records
2. Extracting skills mentioned in job titles, descriptions, and required skills sections
3. Counting the frequency of each skill across the entire dataset
4. Filtering out noise and ranking skills by demand

### Technical Components

- **Mapper (SkillsMapper.java)**: Extracts skills from job descriptions using both predefined skill lists and contextual extraction
- **Reducer (SkillsReducer.java)**: Aggregates and filters skill occurrences
- **Driver (SkillsAnalyzer.java)**: Configures and executes the MapReduce job

## 3. Environment Setup

### Local Hadoop Environment

- **Hadoop Version**: 3.4.1
- **Java Version**: JDK 11
- **OS**: macOS
- **Execution Mode**: Local (Standalone)

## 4. Execution Results

### Job Statistics

- **Input Size**: 1.7GB (full dataset) and 1.1MB (sample)
- **Records Processed**: 100,000+ (full dataset) and 1,000 (sample)
- **Execution Time**: < 1 second for 1,000 records
- **Memory Usage**: 534MB total heap

## 5. Result Interpretation

The analysis revealed several key insights into the current job market:

Soft skills like communication and management remain highly valued across all job types, appearing in over 50% of job postings. This indicates that employers prioritize interpersonal and leadership abilities alongside technical expertise. Technical skills analysis shows that data-related skills (analysis, data management) are increasingly important, appearing in over 25% of all job descriptions.

The high frequency of design, development, and software skills demonstrates the continued growth in technology-focused roles. Security skills appearing in the top 10 reflect growing concerns about cybersecurity across industries.

Performance-wise, our MapReduce implementation processed the job posting dataset efficiently, with good scalability potential for larger datasets. The pattern detection accuracy was high, though some domain-specific terminology may have been missed in specialized fields.

## Documentation and Code Structure

### MapReduce Components

#### SkillsMapper.java

- **Function**: Extracts skills from job descriptions, titles, and skill fields
- **Features**: CSV parsing with embedded comma handling, case-insensitive matching
- **Output**: (skill_name, 1) pairs

#### SkillsReducer.java

- **Function**: Aggregates skill counts and filters noise
- **Features**: Minimum threshold filtering (10+ occurrences)
- **Output**: (skill_name, total_count) pairs

#### SkillsAnalyzer.java

- **Function**: Configures and executes MapReduce job
- **Features**: Memory optimization, combiner usage
- **Configuration**: 2GB mapper/reducer memory

## Project Files

### Source Code

- **SkillsMapper.java**: Implements the map function to extract skills from job descriptions
- **SkillsReducer.java**: Implements the reduce function to aggregate skill counts
- **SkillsAnalyzer.java**: Driver class that configures and runs the MapReduce job

### Scripts

- **run_local.sh**: Script to run the MapReduce job locally
- **generate_report.sh**: Script to generate a formatted report of top skills

### Documentation

- **PROJECT_README.md**: Complete setup and running instructions
- **RESULTS_ANALYSIS.md**: Detailed analysis of the results
- **execution_log.txt**: Log of job execution with performance metrics

### Evidence

- **Screenshots**: Located in the screenshots/ directory
- **Output samples**: Located in the output/ directory
- **Input data sample**: Sample of job_descriptions.csv in input/ directory

## Execution Environment

### Hadoop Setup

```bash
Hadoop 3.4.1
JAVA_HOME: /Library/Java/JavaVirtualMachines/jdk-11.0.16.jdk/Contents/Home
HADOOP_HOME: /Users/pramithajayasooriya/Desktop/Hadoop/hadoop
```

### Execution Log Summary

```
Job job_local160832138_0001 completed successfully
Map input records=1000
Map output records=18225  
Reduce output records=347
Processing time: <1 second
```

## Running Instructions

### Prerequisites

- Java 8 or higher
- Hadoop 3.4.1 installed
- Dataset file placed in input directory

### Steps to Run

1. Compile the source code:

```bash
mkdir -p classes
javac -cp $HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/* -d classes src/*.java
```

2. Create the JAR file:

```bash
jar -cvf skills-analyzer.jar -C classes .
```

3. Run the MapReduce job:

```bash
./run_local.sh
```

4. Generate the report:

```bash
./generate_report.sh
```

### Repository Structure

```
hadoop_project/
├── src/                    # Source code files
├── input/                 # Dataset files
├── output/               # Results directory
├── skills-analyzer.jar   # Executable JAR
├── run_local.sh          # Script to run job
├── generate_report.sh    # Script to generate report
├── PROJECT_README.md     # Detailed setup instructions
├── PROJECT_SUMMARY.md    # This summary file
├── RESULTS_ANALYSIS.md   # Detailed results analysis
└── execution_log.txt     # Execution evidence
```

## 5. Spark Integration

As an extension to our original MapReduce implementation, we have also implemented the same analyses using Apache Spark to demonstrate the power and flexibility of different big data processing frameworks.

### Spark Implementation

Our Spark implementation includes:

1. **SparkSalaryAnalyzer**: Analyzes salary information across job titles

   - Uses RDDs to process job description data
   - Extracts salary ranges using regular expressions
   - Calculates statistics like minimum, maximum, and average salaries
   - Aggregates data by job title
2. **SparkSkillsAnalyzer**: Analyzes technical skills frequency

   - Processes unstructured text from job descriptions
   - Extracts technical skills using a predefined dictionary
   - Counts skill occurrences and ranks them by frequency
   - Filters low-frequency terms to reduce noise

### Advantages of Spark Implementation

The Spark implementation offers several benefits over traditional MapReduce:

1. **Performance**: In-memory processing leads to significantly faster execution times
2. **Code Simplicity**: More concise code with a higher-level API
3. **Versatility**: Same framework can be used for batch, streaming, and interactive analysis
4. **Advanced Analytics**: Native support for machine learning and graph processing
5. **Ease of Development**: Interactive shell for testing and development

### Comparative Analysis

Our project provides a unique opportunity to compare both frameworks:


| Aspect           | Hadoop MapReduce             | Apache Spark                      |
| ---------------- | ---------------------------- | --------------------------------- |
| Processing Model | Disk-based                   | In-memory                         |
| Performance      | Good for very large datasets | Faster for most workloads         |
| Code Complexity  | More verbose                 | More concise                      |
| Learning Curve   | Steeper                      | More accessible                   |
| Fault Tolerance  | Very robust                  | Good, with lineage-based recovery |

### Integration Results

The integration of Spark has expanded the project's capabilities:

- Both implementations produce comparable analytical results
- Spark implementation shows significant performance improvements
- The dual implementation approach demonstrates versatility in big data processing
- Reports generated from both frameworks can be compared for educational purposes

## 6. Report Generation

The project includes comprehensive report generation capabilities:

1. **MapReduce Reports**:

   - `COMPREHENSIVE_SALARY_REPORT.md`: Detailed salary analysis
   - `RESULTS_ANALYSIS.md`: Skills frequency analysis
2. **Spark Reports**:

   - `SPARK_SALARY_ANALYSIS_REPORT.md`: Spark-based salary analysis
   - `SPARK_SKILLS_ANALYSIS_REPORT.md`: Spark-based skills analysis

Each report includes visualizations, statistics, and insights derived from the data.
