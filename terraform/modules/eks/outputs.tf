# EKS cluster outputs
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

# OIDC Provider ARN
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.*.arn[0] # safe even if count = 0
  description = "ARN of the OIDC provider for the cluster"
}

# OIDC Provider URL
output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.this.*.url[0] # safe even if count = 0
  description = "URL of the OIDC provider for the cluster"
}
