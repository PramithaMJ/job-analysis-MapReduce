import java.io.IOException;
import java.util.StringTokenizer;
import java.util.Arrays;
import java.util.List;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class SkillsMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    
    private final static IntWritable one = new IntWritable(1);
    private Text skill = new Text();
    
    // Common technical skills to look for in job descriptions
    private static final List<String> TECHNICAL_SKILLS = Arrays.asList(
        "java", "python", "javascript", "sql", "html", "css", "react", "angular", "node.js", "spring",
        "hibernate", "mysql", "postgresql", "mongodb", "oracle", "aws", "azure", "docker", "kubernetes",
        "git", "jenkins", "maven", "gradle", "junit", "selenium", "rest", "api", "microservices",
        "linux", "unix", "bash", "shell", "agile", "scrum", "devops", "ci/cd", "json", "xml",
        "machine learning", "data science", "artificial intelligence", "big data", "hadoop", "spark",
        "tensorflow", "pytorch", "pandas", "numpy", "r", "scala", "go", "c++", "c#", ".net",
        "ruby", "php", "swift", "kotlin", "flutter", "react native", "vue.js", "bootstrap",
        "elasticsearch", "redis", "kafka", "rabbitmq", "nginx", "apache", "tomcat",
        "tableau", "power bi", "excel", "word", "powerpoint", "sharepoint", "salesforce",
        "sap", "erp", "crm", "project management", "communication", "leadership", "teamwork"
    );
    
    @Override
    public void map(LongWritable key, Text value, Context context) 
            throws IOException, InterruptedException {
        
        // Skip header row (first line)
        if (key.get() == 0) {
            return;
        }
        
        // Convert input line to lowercase for case-insensitive matching
        String line = value.toString().toLowerCase();
        
        // Extract skills column (column index 19 - skills field)
        String[] columns = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)"); // Handle CSV with commas in quotes
        
        if (columns.length > 19) {
            String skillsText = columns[19]; // Skills column
            String jobDescription = columns.length > 17 ? columns[17] : ""; // Job Description column
            String jobTitle = columns.length > 14 ? columns[14] : ""; // Job Title column
            
            // Combine skills, job description, and job title for comprehensive skill extraction
            String combinedText = skillsText + " " + jobDescription + " " + jobTitle;
            
            // Remove quotes and clean the text
            combinedText = combinedText.replaceAll("\"", "").replaceAll("[{}']", "");
            
            // Check for each technical skill in the combined text
            for (String techSkill : TECHNICAL_SKILLS) {
                if (combinedText.contains(techSkill.toLowerCase())) {
                    skill.set(techSkill);
                    context.write(skill, one);
                }
            }
            
            // Also extract individual words from skills field for additional analysis
            StringTokenizer tokenizer = new StringTokenizer(skillsText.replaceAll("[{}\"',]", " "));
            while (tokenizer.hasMoreTokens()) {
                String word = tokenizer.nextToken().trim().toLowerCase();
                // Only include meaningful skill words (length > 2)
                if (word.length() > 2 && !word.matches(".*\\d.*")) { // Exclude words with numbers
                    skill.set(word);
                    context.write(skill, one);
                }
            }
        }
    }
}
