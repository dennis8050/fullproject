provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "../../../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  env = var.env
  project_name = var.project_name
  
}

module "eks" {
  source               = "../../../modules/eks"
  cluster_name         = "${var.project_name}-${var.env}"
  private_subnets      = module.vpc.private_subnets
  node_type            = var.eks_node_type
  node_count           = var.eks_node_count
  create_oidc_provider = var.create_oidc_provider
aws_region = var.aws_region
vpc_id = module.vpc
  depends_on = [module.vpc]
}
module "alb_controller" {
  source = "../../../modules/alb-controller"

  cluster_name      = module.eks.cluster_name
  region            = var.aws_region
  vpc_id            = module.eks.vpc_id
  alb_irsa_role_arn = module.irsa_role.alb_irsa_role_arn
}


module "irsa-role" {
  source            = "../../../modules/irsa-role"
  
  cluster_name        = module.eks.cluster_name
  env                 = var.env
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  aws_account_id = var.aws_account_id


}
module "eks-addons" {
  source = "../../../modules/eks-addons"
  
  # Pass the EBS IRSA role ARN to the Helm module
  ebs_csi_role_arn = module.irsa-role.ebs_csi_irsa_arn
  cluster_name = module.eks.cluster_name
  depends_on = [ module.eks, module.irsa-role ]
}