module "ecr" {
  source = "../../modules/ecr"
  frontend_repo_name = var.frontend_repo_name
  backend_repo_name  = var.backend_repo_name
}

module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
  project_name   = var.project_name
  azs = var.azs
  env = var.env
  
}

module "eks" {
  source       = "../../modules/eks"
  cluster_name = "${var.project_name}-${var.env}"
  
  private_subnets      = module.vpc.private_subnets
  node_type    = var.eks_node_type
  node_count   = var.eks_node_count
   aws_region = var.aws_region
  create_oidc_provider = true

    depends_on = [
    module.vpc
  ]
}

output "eks_oidc_arn" {
  value = module.eks.oidc_provider_arn
}

output "eks_oidc_url" {
  value = module.eks.oidc_provider_url
}





############################
# ArgoCD Module
############################



module "argocd" {
  source = "../../modules/argocd"
    env       = var.env
  namespace = "argocd-${var.env}"

    depends_on = [
    module.eks
  ]
}


module "loki_storage" {
  source             = "../../modules/storage"
 
  storage_class_name = "gp2"
  app_name           = "loki"
  storage_size       = "10Gi"
  depends_on = [
  module.eks
 
]
}

module "monitoring" {
  source = "../../modules/monitoring"
      env       = var.env
  namespace = "monitoring-${var.env}"
  sso_client_id = var.sso_client_id
  sso_client_secret = var.sso_client_secret
  sso_auth_url = var.sso_auth_url
  sso_token_url = var.sso_token_url
  sso_api_url = var.sso_api_url
  monitoring_domain = var.monitoring_domain
  ssl_certificate_arn = var.ssl_certificate_arn


 depends_on = [
  module.eks,
  module.loki_storage
 
]
 loki_existing_claim = module.loki_storage.pvc_name

}

module "irsa-role" {
  source       = "../../modules/irsa-role"
  cluster_name = module.eks.cluster_name
  env          = var.env
  region = var.aws_region
}


module "eks-addons" {
  source = "../../modules/eks-addons"
  
  # Pass the EBS IRSA role ARN to the Helm module
  ebs_csi_irsa_arn = module.irsa-role.ebs_csi_irsa_arn
}





  
