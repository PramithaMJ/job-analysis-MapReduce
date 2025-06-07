#!/usr/bin/env python3
import sys

current_title = None
min_salary = float('inf')
max_salary = 0
total_salary = 0
count = 0

def emit_result(title, min_salary, max_salary, total_salary, count):
    if count == 0:
        return
    avg_salary = total_salary / count
    print(f"{title}\t{min_salary:.2f},{max_salary:.2f},{avg_salary:.2f},{count}")

for line in sys.stdin:
    try:
        line = line.strip()
        if not line:
            continue

        title, value = line.split('\t')
        parts = value.split(',')

        min_val = float(parts[0])
        max_val = float(parts[1])
        avg_val = float(parts[2])
        val_count = int(parts[3])

        if current_title is None:
            current_title = title

        if title != current_title:
            emit_result(current_title, min_salary, max_salary, total_salary, count)
            # Reset for new job title
            current_title = title
            min_salary = float('inf')
            max_salary = 0
            total_salary = 0
            count = 0

        min_salary = min(min_salary, min_val)
        max_salary = max(max_salary, max_val)
        total_salary += avg_val * val_count
        count += val_count

    except Exception:
        continue

# Emit last job title result
if current_title is not None:
    emit_result(current_title, min_salary, max_salary, total_salary, count)
