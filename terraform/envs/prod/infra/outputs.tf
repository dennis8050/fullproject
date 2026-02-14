output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}



output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}



output "oidc_provider_url" {
  value       = module.eks.oidc_provider_url
  description = "OIDC provider URL from the EKS module"
}
output "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  value       = module.eks.vpc_id
}


output "alb_irsa_role_arn" {
  value = module.irsa-role.alb_irsa_arn
}