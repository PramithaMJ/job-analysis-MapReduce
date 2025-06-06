import java.io.IOException;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class SalaryReducer extends Reducer<Text, Text, Text, Text> {
    private final Text result = new Text();
    
    @Override
    public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        double minSalary = Double.MAX_VALUE;
        double maxSalary = 0;
        double totalSalary = 0;
        int count = 0;
        
        for (Text val : values) {
            String[] parts = val.toString().split(",");
            double min = Double.parseDouble(parts[0]);
            double max = Double.parseDouble(parts[1]);
            double avg = Double.parseDouble(parts[2]);
            int valCount = Integer.parseInt(parts[3]);
            
            // Update statistics
            minSalary = Math.min(minSalary, min);
            maxSalary = Math.max(maxSalary, max);
            totalSalary += (avg * valCount);
            count += valCount;
        }
        
        // Calculate the average
        double avgSalary = (count > 0) ? totalSalary / count : 0;
        
        // Format the result as Min, Max, Avg, Count
        String resultStr = String.format("%.2f,%.2f,%.2f,%d", 
                minSalary, maxSalary, avgSalary, count);
        result.set(resultStr);
        context.write(key, result);
    }
}