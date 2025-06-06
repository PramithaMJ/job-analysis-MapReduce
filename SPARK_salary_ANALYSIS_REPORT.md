# Comprehensive Spark Salary Analysis Report
**Generated on:** Fri Jun  6 15:26:59 +0530 2025

## Executive Summary
This report presents a detailed analysis of salary data across various job titles, processed using Apache Spark technology. The analysis provides insights into salary distributions, trends, and comparative statistics across different job roles.

## Results from Spark Analysis

| Job Title | Min Salary | Max Salary | Avg Salary | Count |
|-----------|------------|------------|------------|-------|
| Account Director | $67,500.00 | $97,500.00 | $82,511.19 | 6926 |
| Account Executive | $67,500.00 | $97,500.00 | $82,452.67 | 10511 |
| Account Manager | $67,500.00 | $97,500.00 | $82,401.46 | 13888 |
| Accountant | $67,500.00 | $97,500.00 | $82,495.82 | 10517 |
| Administrative Assistant | $67,500.00 | $97,500.00 | $82,476.61 | 17484 |
| Aerospace Engineer | $67,500.00 | $97,500.00 | $82,443.73 | 10441 |
| Architect | $67,500.00 | $97,500.00 | $82,438.20 | 13957 |
| Architectural Designer | $67,500.00 | $97,500.00 | $82,443.51 | 6806 |
| Art Director | $67,500.00 | $97,500.00 | $82,515.60 | 10387 |
| Art Teacher | $67,500.00 | $97,500.00 | $82,586.94 | 10611 |
| Back-End Developer | $67,500.00 | $97,500.00 | $82,427.03 | 6982 |
| Brand Ambassador | $67,500.00 | $97,500.00 | $82,495.63 | 10637 |
| Brand Manager | $67,500.00 | $97,500.00 | $82,500.90 | 10514 |
| Business Analyst | $67,500.00 | $97,500.00 | $82,500.29 | 10286 |
| Business Development Manager | $67,500.00 | $97,500.00 | $82,396.84 | 10324 |
| Chemical Analyst | $67,500.00 | $97,500.00 | $82,427.99 | 10464 |
| Chemical Engineer | $67,500.00 | $97,500.00 | $82,546.74 | 10345 |
| Civil Engineer | $67,500.00 | $97,500.00 | $82,526.80 | 13674 |
| Content Writer | $67,500.00 | $97,500.00 | $82,498.45 | 13869 |
| Copywriter | $67,500.00 | $97,500.00 | $82,466.28 | 10438 |

## Methodology
The data was processed using Apache Spark with the following steps:
1. **Data Collection**: Job listings were collected from a comprehensive dataset.
2. **Parsing**: Relevant information was extracted from job listings.
3. **Analysis**: Apache Spark was used to process and aggregate the data.

### Technical Implementation
- **Data Loading**: Input CSV data was loaded with automatic handling of quoted fields and commas.
- **Transformation**: RDDs were used to transform and process the data.
- **Reduction**: reduceByKey operation was used to aggregate results.

## System Information
- **Date:** Fri Jun  6 15:26:59 +0530 2025
- **User:** pramithajayasooriya
- **Platform:** Darwin Pramithas-MacBook-M2.local 24.5.0 Darwin Kernel Version 24.5.0: Tue Apr 22 19:54:26 PDT 2025; root:xnu-11417.121.6~2/RELEASE_ARM64_T8112 arm64

## Note on Spark Integration
This analysis was performed using Apache Spark, which offers several advantages:
1. **Speed**: In-memory processing for faster computation
2. **Simplicity**: More concise code for complex analysis
3. **Scalability**: Ability to process large datasets efficiently
4. **Versatility**: Support for various data processing needs
