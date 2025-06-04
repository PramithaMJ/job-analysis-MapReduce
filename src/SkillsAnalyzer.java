import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class SkillsAnalyzer {
    
    public static void main(String[] args) throws Exception {
        
        // Check if correct number of arguments provided
        if (args.length != 2) {
            System.err.println("Usage: SkillsAnalyzer <input path> <output path>");
            System.exit(-1);
        }
        
        // Print job information for logging purposes
        System.out.println("========================================================================================");
        System.out.println("                          TECHNICAL SKILLS ANALYZER - HADOOP MAPREDUCE JOB              ");
        System.out.println("========================================================================================");
        System.out.println("Job started at: " + new java.util.Date());
        System.out.println("Input path: " + args[0]);
        System.out.println("Output path: " + args[1]);
        
        Configuration conf = new Configuration();
        
        // Set configuration parameters for better performance
        conf.set("mapreduce.map.memory.mb", "2048");
        conf.set("mapreduce.reduce.memory.mb", "2048");
        conf.set("mapreduce.map.java.opts", "-Xmx1536m");
        conf.set("mapreduce.reduce.java.opts", "-Xmx1536m");
        
        Job job = Job.getInstance(conf, "skills analysis");
        job.setJarByClass(SkillsAnalyzer.class);
        
        // Set mapper and reducer classes
        job.setMapperClass(SkillsMapper.class);
        job.setCombinerClass(SkillsReducer.class);
        job.setReducerClass(SkillsReducer.class);
        
        // Set output key and value types
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        
        // Set input and output paths
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        
        // Wait for the job to complete and exit with appropriate code
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
