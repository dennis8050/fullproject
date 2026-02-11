module "argocd" {
  source    = "../../modules/argocd"
  namespace = "argocd-prod"
}

module "monitoring" {
  source    = "../../modules/monitoring"
  namespace = "monitoring"
}

module "irsa" {
  source            = "../../modules/irsa-role"
  cluster_name      = data.terraform_remote_state.infra.outputs.cluster_name
  oidc_provider_arn = data.terraform_remote_state.infra.outputs.oidc_provider_arn
}
