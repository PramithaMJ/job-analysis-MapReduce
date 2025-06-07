output "hadoop_master_public_ip" {
  value       = aws_instance.hadoop_master.public_ip
  description = "Public IP address of the Hadoop master node"
}

output "hadoop_master_private_ip" {
  value       = aws_instance.hadoop_master.private_ip
  description = "Private IP address of the Hadoop master node"
}

output "hadoop_workers_public_ips" {
  value       = aws_instance.hadoop_workers[*].public_ip
  description = "Public IP addresses of the Hadoop worker nodes"
}

output "hadoop_workers_private_ips" {
  value       = aws_instance.hadoop_workers[*].private_ip
  description = "Private IP addresses of the Hadoop worker nodes"
}
