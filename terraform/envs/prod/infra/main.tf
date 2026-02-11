provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "eks" {
  source               = "../../modules/eks"
  cluster_name         = "${var.project_name}-${var.env}"
  private_subnets      = module.vpc.private_subnets
  node_type            = var.eks_node_type
  node_count           = var.eks_node_count
  create_oidc_provider = var.create_oidc_provider

  depends_on = [module.vpc]
}
