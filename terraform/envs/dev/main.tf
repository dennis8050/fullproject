provider "aws" { region = "us-east-1" }

module "vpc" {
  source          = "../../modules/vpc"
  name            = "dev"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24","10.0.102.0/24"]
  azs             = ["us-east-1a","us-east-1b"]
   cluster_name = "dev-eks" 
}

module "eks" {
  source           = "../../modules/eks"
  cluster_name     = "dev-eks"
  #cluster_role_arn = module.eks.aws_iam_role.eks_cluster_role.arn
  #node_role_arn    = module.eks.aws_iam_role.eks_node_role.arn

  private_subnets  = module.vpc.private_subnet_ids
}
