# Technical Skills Analysis using MapReduce

## University of Ruhuna - Faculty of Engineering
### Assignment 1 - Semester 7 (May 2025)
### Module: Cloud Computing (EC7205)
### Deadline: June 7, 2025

## Team Members
1. Pramitha Jayasooriya (ENG/2021/XXX)
2. [Team Member 2] (ENG/2021/XXX)
3. [Team Member 3] (ENG/2021/XXX)

## Project Overview

This project implements a Hadoop MapReduce job to analyze job description data and identify the most in-demand technical skills in the job market. By extracting and counting skills mentioned in job descriptions, the analysis provides valuable insights into current skill requirements across various industries.

## Repository Structure

- `src/` - Java source code for MapReduce implementation
  - `SkillsAnalyzer.java` - Driver class for the MapReduce job
  - `SkillsMapper.java` - Mapper implementation for extracting skills
  - `SkillsReducer.java` - Reducer implementation for aggregating skill counts
- `input/` - Input data directory
  - `job_descriptions.csv` - Dataset with job postings
- `output/` - Generated output from MapReduce job
- `build.sh` - Script to compile code and build JAR
- `run_local.sh` - Script to run the job in local mode
- `generate_report.sh` - Script to generate a summary report of results
- `capture_evidence.sh` - Script to capture evidence of execution
- `PROJECT_README.md` - Detailed technical documentation
- `PROJECT_SUMMARY.md` - Summary of project and findings
- `RESULTS_ANALYSIS.md` - In-depth analysis of results
- `execution_log.txt` - Log of MapReduce job execution
- `skills-analyzer.jar` - Compiled MapReduce application

## Dataset Description

We used a job descriptions dataset containing detailed information about job postings, including:

- Job titles and descriptions
- Required skills and qualifications
- Company information
- Salary ranges
- Job locations and other metadata

The dataset contains over 100,000 records and is approximately 1.7GB in size, stored in CSV format. Key columns used in our analysis include:
- Column 14: Job Title
- Column 17: Job Description
- Column 19: Skills

## How to Run

### Prerequisites
- Java JDK 11 or higher
- Hadoop 3.4.1 installed and configured
- CSV dataset in the input directory

### Steps

1. **Build the project**
   ```bash
   ./build.sh
   ```

2. **Run in local mode**
   ```bash
   ./run_local.sh
   ```

3. **Generate a report**
   ```bash
   ./generate_report.sh
   ```

4. **Capture execution evidence**
   ```bash
   ./capture_evidence.sh
   ```

## Key Results

Our MapReduce analysis revealed the following top skills in the job market:

1. Communication (5931 occurrences)
2. Management (5198 occurrences) 
3. Design (3371 occurrences)
4. Analysis (3283 occurrences)
5. Data (2548 occurrences)

The complete analysis can be found in `RESULTS_ANALYSIS.md`.

## Performance Statistics

- Map input records: 10,000
- Map output records: 181,219
- Combine input records: 181,219
- Combine output records: 1,091
- Reduce output records: 1,091
- Processing time: ~3 seconds (local mode)

## Insights and Conclusions

The analysis reveals the continued importance of both technical and soft skills in the job market, with communication and management skills being the most in-demand. Among technical skills, design, analysis, and data skills are particularly valuable.

Our MapReduce implementation demonstrated efficient processing of semi-structured text data, with effective use of combiners to reduce the data transferred between mappers and reducers.

## Future Improvements

1. Implement more sophisticated NLP techniques for skill extraction
2. Add industry-specific and geographical analysis
3. Incorporate salary data to identify high-value skills
4. Scale to the full dataset using a Hadoop cluster
5. Create visualizations of skill demand trends

---
*This project was completed as part of the Cloud Computing (EC7205) course at the University of Ruhuna, Faculty of Engineering.*
