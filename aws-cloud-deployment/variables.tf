variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "ami" {
  description = "Amazon Machine Image ID"
  type        = string
  default     = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS in us-west-2
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "hadoop_version" {
  description = "Hadoop version to install"
  type        = string
  default     = "3.4.1"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.2.0/24"
}
