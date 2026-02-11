module "argocd" {
  source    = "../../modules/argocd"
  namespace = "argocd-prod"
}

module "monitoring" {
  source    = "../../../modules/monitoring"
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

module "irsa" {
  source            = "../../../modules/irsa-role"
  
  cluster_name        = module.eks.cluster_name
  env                 = var.env
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  
  depends_on = [module.eks]
}
module "eks-addons" {
  source = "../../../modules/eks-addons"
  
  # Pass the EBS IRSA role ARN to the Helm module
  ebs_csi_irsa_arn = module.irsa-role.ebs_csi_irsa_arn
}