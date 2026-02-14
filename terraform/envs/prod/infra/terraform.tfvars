project_name   = "dens"
env            = "prod"
aws_region     = "us-east-1"
aws_account_id = "123456789012"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

azs = ["us-east-1a", "us-east-1b"]

eks_node_type  = "t3.large"
eks_node_count = 6
