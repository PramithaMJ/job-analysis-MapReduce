import java.io.IOException;
import java.util.StringTokenizer;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

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
        "tensorflow", "pytorch", "pandas", "numpy", "scala", "c++", "c#", ".net",
        "ruby", "php", "swift", "kotlin", "flutter", "react native", "vue.js", "bootstrap",
        "elasticsearch", "redis", "kafka", "rabbitmq", "nginx", "apache", "tomcat",
        "tableau", "power bi", "excel", "sharepoint", "salesforce",
        "sap", "erp", "crm"
    );
    
    // Stopwords list for filtering out common words that are not skills
    private static final Set<String> STOPWORDS = new HashSet<>(Arrays.asList(
        "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", 
        "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", 
        "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", 
        "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", 
        "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", 
        "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", 
        "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me", "more", 
        "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", 
        "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "shan't", "she", 
        "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", 
        "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", 
        "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", 
        "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", 
        "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", 
        "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", 
        "your", "yours", "yourself", "yourselves", 
        "e.g", "e.g.", "r", "etc", "eg", "eg.", "etc.", "go", 
        "detail", "details", "using", "use", "used", "like", "including", "includes",
        "required", "requirements", "(e.g", "(e.g.)", "etc.)", "etc)", "ability", "experience", 
        "skills", "skill", "management", "communication", "analysis", "design", "data", "planning",
        "knowledge", "development", "tools", "research", "problem-solving", "attention",
        "software", "marketing", "detail", "word", "powerpoint", "project", "leadership", "teamwork",
        "will", "work", "working", "team", "responsibilities", "role", "position", "job", "company",
        "years", "year", "month", "months", "day", "days", "hr"
    ));
    
    // Pattern to match any string containing parentheses
    private static final Pattern PARENTHESES_PATTERN = Pattern.compile(".*[\\(\\)].*");
    
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
            
            // Extract individual words from skills field for additional analysis
            StringTokenizer tokenizer = new StringTokenizer(
                skillsText.replaceAll("[{}\"',]", " "), " \t\n\r\f,;:.!?()[]{}'\"-_/\\");
                
            while (tokenizer.hasMoreTokens()) {
                String word = tokenizer.nextToken().trim().toLowerCase();
                
                // Skip words with these conditions:
                // 1. Words containing parentheses
                // 2. Words that are too short (≤ 2 chars)
                // 3. Words with numbers
                // 4. Words in our stopword list
                // 5. Words starting with special characters
                if (word.length() > 2 && 
                    !word.matches(".*\\d.*") && 
                    !STOPWORDS.contains(word) && 
                    !PARENTHESES_PATTERN.matcher(word).matches() &&
                    word.matches("^[a-zA-Z].*")) {
                    
                    skill.set(word);
                    context.write(skill, one);
                }
            }
        }
    }
}
