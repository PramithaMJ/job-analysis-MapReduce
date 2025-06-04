import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class SkillsReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    
    private IntWritable result = new IntWritable();
    
    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context) 
            throws IOException, InterruptedException {
        
        int sum = 0;
        
        // Sum up the occurrences of each skill
        for (IntWritable value : values) {
            sum += value.get();
        }
        
        // Only output skills that appear at least 10 times to filter noise
        if (sum >= 10) {
            result.set(sum);
            context.write(key, result);
        }
    }
}
