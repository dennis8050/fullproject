module "vpc" {
  source = "../../modules/vpc"
  
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  project_name    = var.project_name
}

module "ecr" {
  source = "../../modules/ecr"
  
  frontend_repo_name = var.frontend_repo_name
  backend_repo_name  = var.backend_repo_name
}

module "eks" {
  source = "../../modules/eks"

  cluster_name  = "${var.project_name}-stage"
  vpc_id        = module.vpc.vpc_id
  subnets       = module.vpc.private_subnets
  node_type     = var.eks_node_type
  node_count    = var.eks_node_count

  cluster_role_arn = aws_iam_role.eks_cluster_role.arn   # your cluster role
  node_role_arn    = aws_iam_role.node_group_role.arn   # new node role
}



module "irsa" {
  source       = "../../modules/irsa-role"
  cluster_name = module.eks.cluster_name
  region       = var.aws_region
}

# ✅ Keep only the new SSO module
module "iam_sso" {
  source = "./../modules/iam-sso-role"

  project_name      = var.project_name
  aws_account_id    = var.aws_account_id
  sso_instance_arn  = var.sso_instance_arn
  sso_instance_name = var.sso_instance_name
  sso_groups        = var.sso_groups
}
