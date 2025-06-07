#!/usr/bin/env python3
import sys
import csv
import re

# Regex to capture salary ranges like "$50K - $80K" or "50000 - 80000"
salary_pattern = re.compile(r'\$?(\d+)K?\s*-\s*\$?(\d+)K?')

def parse_salary(salary_str):
    try:
        match = salary_pattern.search(salary_str)
        if match:
            min_salary = float(match.group(1))
            max_salary = float(match.group(2))
            if 'K' in salary_str.upper():
                min_salary *= 1000
                max_salary *= 1000
            return (min_salary + max_salary) / 2
    except:
        pass
    return 0

for line in sys.stdin:
    try:
        # Use csv.reader to handle quoted fields and commas inside quotes
        reader = csv.reader([line])
        fields = next(reader)

        if len(fields) < 15:
            continue

        job_title = fields[14].strip()
        if not job_title or job_title.lower() == "job title":
            continue

        salary_field = fields[3].strip()
        avg_salary = parse_salary(salary_field)

        if avg_salary > 0:
            # Output format: key<TAB>value
            # value = min,max,avg,count → all set to avg for mapper
            print(f"{job_title}\t{avg_salary},{avg_salary},{avg_salary},1")

    except Exception:
        continue  # skip malformed lines
