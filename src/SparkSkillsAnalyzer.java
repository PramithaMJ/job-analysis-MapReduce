package src;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Spark implementation for skills analysis
 * University of Ruhuna - EC7205 Cloud Computing
 * Date: June 6, 2025
 */
public class SparkSkillsAnalyzer {

    // Technical skills dictionary
    private static final Set<String> SKILLS_DICTIONARY = new HashSet<>(Arrays.asList(
        "java", "python", "javascript", "c++", "c#", "ruby", "php", "swift", "kotlin", "go",
        "react", "angular", "vue", "node", "express", "django", "flask", "spring", "hibernate", 
        "docker", "kubernetes", "aws", "azure", "gcp", "terraform", "jenkins", "git", "ci/cd",
        "sql", "nosql", "mongodb", "postgresql", "mysql", "oracle", "redis", "elasticsearch",
        "machine learning", "artificial intelligence", "data science", "big data", "hadoop", "spark",
        "tableau", "power bi", "data visualization", "nlp", "computer vision", "deep learning",
        "agile", "scrum", "devops", "microservices", "rest api", "graphql", "websocket", "oauth"
    ));

    private static final Pattern WORD_SPLITTER = Pattern.compile("\\W+");

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage: SparkSkillsAnalyzer <input_path> <output_path>");
            System.exit(1);
        }

        String inputPath = args[0];
        String outputPath = args[1];

        // Initialize Spark
        SparkConf conf = new SparkConf().setAppName("Spark Skills Analyzer");
        JavaSparkContext sc = new JavaSparkContext(conf);

        // Read input data
        JavaRDD<String> lines = sc.textFile(inputPath);

        // Extract skills from job descriptions
        JavaPairRDD<String, Integer> skillsCount = lines
            .flatMapToPair(line -> {
                // CSV parsing logic similar to SkillsMapper
                String[] fields = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                
                if (fields.length < 20) {
                    return java.util.Collections.emptyIterator();
                }
                
                // Extract job title, description and skills
                String jobTitle = fields.length > 14 ? fields[14].trim().replaceAll("\"", "") : "";
                String jobDescription = fields.length > 17 ? fields[17].trim().replaceAll("\"", "") : "";
                String skillsText = fields.length > 19 ? fields[19].trim().replaceAll("\"", "") : "";
                
                // Combine all text for analysis
                String combinedText = (jobTitle + " " + jobDescription + " " + skillsText).toLowerCase();
                
                // Extract words and check against dictionary
                Set<Tuple2<String, Integer>> foundSkills = new HashSet<>();
                String[] words = WORD_SPLITTER.split(combinedText);
                
                for (String word : words) {
                    word = word.trim();
                    // Filter out numbers, short words
                    if (word.length() < 2 || word.matches(".*\\d+.*")) {
                        continue;
                    }
                    
                    if (SKILLS_DICTIONARY.contains(word)) {
                        foundSkills.add(new Tuple2<>(word, 1));
                    }
                }
                
                // Check for multi-word skills
                for (String skill : SKILLS_DICTIONARY) {
                    if (skill.contains(" ") && combinedText.contains(skill)) {
                        foundSkills.add(new Tuple2<>(skill, 1));
                    }
                }
                
                return foundSkills.iterator();
            });

        // Count occurrences of each skill
        JavaPairRDD<String, Integer> skillsFrequency = skillsCount.reduceByKey(Integer::sum);
        
        // Filter out skills with low frequency (threshold = 10)
        JavaPairRDD<String, Integer> filteredSkills = skillsFrequency.filter(tuple -> tuple._2 >= 10);
        
        // Sort by frequency (optional)
        JavaPairRDD<Integer, String> swappedSkills = filteredSkills.mapToPair(tuple -> 
            new Tuple2<>(tuple._2, tuple._1));
        JavaPairRDD<Integer, String> sortedSkills = swappedSkills.sortByKey(false);
        JavaPairRDD<String, Integer> results = sortedSkills.mapToPair(tuple -> 
            new Tuple2<>(tuple._2, tuple._1));

        // Save results
        results.saveAsTextFile(outputPath);
        
        // Close Spark context
        sc.close();
        
        System.out.println("Spark Skills Analysis completed successfully!");
    }
}
