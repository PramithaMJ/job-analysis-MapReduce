provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "hadoop_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "hadoop-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "hadoop_igw" {
  vpc_id = aws_vpc.hadoop_vpc.id

  tags = {
    Name = "hadoop-igw"
  }
}

# Public Subnet
resource "aws_subnet" "hadoop_public_subnet" {
  vpc_id                  = aws_vpc.hadoop_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "hadoop-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "hadoop_public_rt" {
  vpc_id = aws_vpc.hadoop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hadoop_igw.id
  }

  tags = {
    Name = "hadoop-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "hadoop_public_rt_assoc" {
  subnet_id      = aws_subnet.hadoop_public_subnet.id
  route_table_id = aws_route_table.hadoop_public_rt.id
}

# Security Group
resource "aws_security_group" "hadoop_sg" {
  name        = "hadoop-security-group"
  description = "Security group for Hadoop cluster"
  vpc_id      = aws_vpc.hadoop_vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic within the VPC (crucial for Hadoop communication)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow access to YARN ResourceManager UI
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow access to HDFS NameNode UI
  ingress {
    from_port   = 9870
    to_port     = 9870
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hadoop-security-group"
  }
}

# Master Node
resource "aws_instance" "hadoop_master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.hadoop_public_subnet.id

  vpc_security_group_ids = [aws_security_group.hadoop_sg.id]
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  user_data = templatefile("${path.module}/scripts/master-setup.sh", {
    WORKER_COUNT    = var.worker_count,
  })

  tags = {
    Name = "hadoop-master"
    Role = "master"
  }
}

# Worker Nodes
resource "aws_instance" "hadoop_workers" {
  count         = var.worker_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.hadoop_public_subnet.id

  vpc_security_group_ids = [aws_security_group.hadoop_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  user_data = templatefile("${path.module}/scripts/worker-setup.sh", {
    MASTER_IP      = aws_instance.hadoop_master.private_ip,
  })

  tags = {
    Name = "hadoop-worker-${count.index + 1}"
    Role = "worker"
  }

  depends_on = [aws_instance.hadoop_master]
}