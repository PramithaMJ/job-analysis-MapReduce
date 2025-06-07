aws_region     = "us-west-2"
ami            = "ami-0a605bc2ef5707a18"
key_name       = "hadoop-kp-new"
instance_type  = "t2.medium"
worker_count = 3

vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.2.0/24"