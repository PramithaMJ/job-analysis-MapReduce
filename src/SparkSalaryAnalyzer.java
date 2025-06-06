package src;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;
import scala.Tuple4;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Spark implementation for salary analysis
 * University of Ruhuna - EC7205 Cloud Computing
 * Date: June 6, 2025
 */
public class SparkSalaryAnalyzer {

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage: SparkSalaryAnalyzer <input_path> <output_path>");
            System.exit(1);
        }

        String inputPath = args[0];
        String outputPath = args[1];

        // Initialize Spark
        SparkConf conf = new SparkConf().setAppName("Spark Salary Analyzer");
        JavaSparkContext sc = new JavaSparkContext(conf);

        // Read input data
        JavaRDD<String> lines = sc.textFile(inputPath);

        // Parse and extract salary information
        JavaPairRDD<String, Tuple4<Double, Double, Double, Integer>> salaryData = lines
            .flatMap(line -> {
                // CSV parsing logic similar to SalaryMapper
                String[] fields = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                
                if (fields.length < 18) {
                    return null; // Skip malformed records
                }
                
                String jobTitle = fields[14].trim().replaceAll("\"", "");
                String salaryStr = fields[17].trim().replaceAll("\"", "");
                
                // Skip records without job title or salary
                if (jobTitle.isEmpty() || salaryStr.isEmpty()) {
                    return null;
                }
                
                // Extract salary range using regex
                Pattern pattern = Pattern.compile("\\$(\\d+(?:,\\d+)*)(?:\\s*-\\s*\\$(\\d+(?:,\\d+)*))?");
                Matcher matcher = pattern.matcher(salaryStr);
                
                if (matcher.find()) {
                    String minSalaryStr = matcher.group(1).replace(",", "");
                    double minSalary = Double.parseDouble(minSalaryStr);
                    
                    double maxSalary;
                    if (matcher.group(2) != null) {
                        String maxSalaryStr = matcher.group(2).replace(",", "");
                        maxSalary = Double.parseDouble(maxSalaryStr);
                    } else {
                        maxSalary = minSalary;
                    }
                    
                    double avgSalary = (minSalary + maxSalary) / 2;
                    return java.util.Arrays.asList(new Tuple2<>(jobTitle, new Tuple4<>(minSalary, maxSalary, avgSalary, 1)));
                }
                
                return java.util.Collections.emptyList();
            })
            .mapToPair(tuple -> tuple);

        // Aggregate by job title
        JavaPairRDD<String, Tuple4<Double, Double, Double, Integer>> salaryStats = salaryData
            .reduceByKey((tuple1, tuple2) -> {
                double newMinSalary = Math.min(tuple1._1(), tuple2._1());
                double newMaxSalary = Math.max(tuple1._2(), tuple2._2());
                
                // Calculate weighted average
                double totalSalary1 = tuple1._3() * tuple1._4();
                double totalSalary2 = tuple2._3() * tuple2._4();
                int totalCount = tuple1._4() + tuple2._4();
                double newAvgSalary = (totalSalary1 + totalSalary2) / totalCount;
                
                return new Tuple4<>(newMinSalary, newMaxSalary, newAvgSalary, totalCount);
            });

        // Format results
        JavaPairRDD<String, String> results = salaryStats.mapToPair(tuple -> {
            String jobTitle = tuple._1;
            Tuple4<Double, Double, Double, Integer> stats = tuple._2;
            
            // Format: jobTitle  minSalary,maxSalary,avgSalary,count
            String statsStr = stats._1() + "," + stats._2() + "," + stats._3() + "," + stats._4();
            return new Tuple2<>(jobTitle, statsStr);
        });

        // Save results
        results.saveAsTextFile(outputPath);
        
        // Close Spark context
        sc.close();
        
        System.out.println("Spark Salary Analysis completed successfully!");
    }
}
