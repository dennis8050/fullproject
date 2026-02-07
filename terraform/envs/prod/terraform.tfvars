# ===== NON SECRET VALUES (SAFE IN GIT) =====

project_name   = "dens"
env            = "prod"
aws_region     = "us-east-1"
oidc_role_arn   = "arn:aws:iam::311141540332:role/userRole"

# VPC
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
azs             = ["us-east-1a","us-east-1b"]

# EKS
eks_node_type  = "t3.medium"
eks_node_count = 2

# ECR
frontend_repo_name = "frontend-prod"
backend_repo_name  = "backend-prod"

# GitHub (repo name is not secret)

# Monitoring domain (public)
monitoring_domain = "mygrafana.duckdns.org"
