#!/bin/bash

prefix="salary"

mapper_file="${prefix}_mapper.py"
reducer_file="${prefix}_reducer.py"

chmod +x "$mapper_file" "$reducer_file"

hadoop fs -rm -r /user/tharindu/output 2>/dev/null || true

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/tharindu/input \
  -output /user/tharindu/output \
  -mapper "python3 ./$mapper_file" \
  -reducer "python3 ./$reducer_file" \
  -file "$mapper_file" \
  -file "$reducer_file"

