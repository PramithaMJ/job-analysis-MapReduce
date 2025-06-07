import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class SalaryMapper extends Mapper<LongWritable, Text, Text, Text> {
    private final Text jobTitle = new Text();
    private final Text salaryInfo = new Text();
    private final Pattern salaryPattern = Pattern.compile("\\$?(\\d+)K?\\s*-\\s*\\$?(\\d+)K?");
    
    @Override
    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        try {
            String line = value.toString();
            String[] fields = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");  // CSV splitting accounting for quoted fields
            
            // Skip malformed lines or header
            if (fields.length < 15) {
                return;
            }
            
            // Extract job title (column 15, index 14)
            String title = fields[14].trim();
            if (title.isEmpty() || title.equalsIgnoreCase("job title")) {
                return;  // Skip empty titles or header row
            }
            
            // Extract salary range (column 4, index 3)
            String salaryField = fields[3].trim();
            double avgSalary = parseSalary(salaryField);
            
            if (avgSalary > 0) {
                jobTitle.set(title);
                // Emit salary as: avgSalary,avgSalary,avgSalary,1 (for min,max,avg,count)
                salaryInfo.set(avgSalary + "," + avgSalary + "," + avgSalary + ",1");
                context.write(jobTitle, salaryInfo);
            }
        } catch (Exception e) {
            // Skip any problematic lines
        }
    }
    
    private double parseSalary(String salaryStr) {
        try {
            Matcher matcher = salaryPattern.matcher(salaryStr);
            if (matcher.find()) {
                double min = Double.parseDouble(matcher.group(1));
                double max = Double.parseDouble(matcher.group(2));
                
                // Convert to actual salary if K is in the string
                if (salaryStr.contains("K")) {
                    min *= 1000;
                    max *= 1000;
                }
                
                return (min + max) / 2;
            }
        } catch (Exception e) {
            // Return 0 for unparseable salaries
        }
        return 0;
    }
}