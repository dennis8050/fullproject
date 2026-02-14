


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

 depends_on = [ module.storage_pvc_loki ]

}


module "storage_pvc_loki" {
source            = "../../../modules/storage_pvc_loki"

  namespace         = "monitoring-${var.env}"

}
  