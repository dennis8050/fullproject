


module "argocd" {
  source    = "../../../modules/argocd"
  namespace = "argocd-prod"
  env = var.env
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
  
  module.storage_pvc_loki
 
]
 loki_existing_claim = module.storage_pvc_loki.pvc_name

}

module "irsa-role" {
  source            = "../../../modules/irsa-role"
  
  cluster_name        = data.terraform_remote_state.infra.outputs.cluster_name
  env                 = var.env
  oidc_provider_arn   = data.terraform_remote_state.infra.outputs.oidc_provider_arn
  oidc_provider_url   = data.terraform_remote_state.infra.outputs.oidc_provider_url

}
module "eks-addons" {
  source = "../../../modules/eks-addons"
  
  # Pass the EBS IRSA role ARN to the Helm module
  ebs_csi_irsa_arn = module.irsa-role.ebs_csi_irsa_arn
}
module "storage_pvc_loki" {
source            = "../../../modules/storage_pvc_loki"
app_name = data.terraform_remote_state.infra.outputs.cluster_name
storage_class_name = "gp3"
storage_size = "10Gi"
depends_on = [ module.eks-addons ]
}
  