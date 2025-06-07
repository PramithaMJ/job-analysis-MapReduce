# Salary Analysis Using Hadoop MapReduce

## Summary

This Hadoop MapReduce project analyzes salary data by extracting job titles and salary ranges from a CSV file. The system computes the minimum, maximum, and average salaries, along with the count of job entries for each job title. The analysis is performed in a distributed manner to efficiently process large datasets. The output format for each job title includes the computed statistics: min salary, max salary, average salary, and count.

## Methodology

The implementation consists of three main components:

1. **Mapper (`SalaryMapper.java`)**:

   - Reads each line from the CSV file.
   - Extracts the job title (column 15) and salary range (column 4).
   - Parses the salary using a regular expression to extract min and max values.
   - Computes the average salary.
   - Emits a key-value pair where the key is the job title and the value is a string in the format `avg,avg,avg,1`.

2. **Reducer/Combiner (`SalaryReducer.java`)**:

   - Receives all salary values for a specific job title.
   - Aggregates the minimum, maximum, and total salary while maintaining a count.
   - Computes the final average salary using a weighted average.
   - Outputs the result as `min,max,avg,count` for each job title.

3. **Driver (`SalaryAnalyzer.java`)**:
   - Configures the Hadoop job.
   - Sets the Mapper, Combiner, and Reducer classes.
   - Defines the input and output paths.

## Results

The program generates output in the format:

```

<job title> <min salary>,<max salary>,<avg salary>,<count>

```

Example:

```

Software Engineer 60000.00,160000.00,102500.00,120
Data Scientist 80000.00,180000.00,125500.00,85

```

## Interpretation

The results provide a statistical summary of salary distributions for each job title. The minimum and maximum values indicate the range of salaries, while the average reflects the central tendency, weighted by the number of observations. The count represents how many times the job title appeared in the dataset. This analysis can be used for evaluating market trends, assessing salary competitiveness, and supporting data-driven HR decisions.
