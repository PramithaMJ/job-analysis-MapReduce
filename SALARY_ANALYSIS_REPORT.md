# Salary Analysis Report
**Generated on:** Fri Jun  6 14:17:35 +0530 2025

## Overview
This report analyzes salary data from job listings processed with Hadoop MapReduce.

## Salary Statistics by Job Title

| Job Title | Min Salary | Max Salary | Avg Salary | Count |
|-----------|------------|------------|------------|-------|
| Digital Marketing Specialist | $79,000.00 | $79,000.00 | $79,000.00 | 1 |
| Network Engineer | $78,000.00 | $78,000.00 | $78,000.00 | 1 |
| Operations Manager | $82,500.00 | $82,500.00 | $82,500.00 | 1 |
| Web Developer | $86,000.00 | $86,000.00 | $86,000.00 | 1 |

## Summary Statistics
- **Total Job Titles Analyzed:** 4
- **Overall Average Salary:** $81,375.00
- **Highest Paying Job:** Web Developer ($86,000.00)
- **Lowest Paying Job:** Network Engineer ($78,000.00)

## Methodology
The salary data was processed using a Hadoop MapReduce job that:
1. Parsed salary ranges from job listings (e.g., "0K - output/salary_local_test00K")
2. Calculated average salaries for each job title
3. Aggregated statistics by job title to find minimums, maximums, and averages

## System Information
- **Date:** Fri Jun  6 14:17:35 +0530 2025
- **Hadoop Version:** Hadoop 3.4.1
- **User:** pramithajayasooriya
- **Platform:** Darwin Pramithas-MacBook-M2.local 24.5.0 Darwin Kernel Version 24.5.0: Tue Apr 22 19:54:26 PDT 2025; root:xnu-11417.121.6~2/RELEASE_ARM64_T8112 arm64
