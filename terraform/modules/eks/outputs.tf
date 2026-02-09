# -----------------------------
# EKS Cluster Outputs
# -----------------------------
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

# -----------------------------
# OIDC Provider Outputs
# -----------------------------
# Use a data source to safely reference an existing OIDC provider
data "aws_iam_openid_connect_provider" "eks" {
  url = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${module.eks.cluster_oidc_id}"
}

output "oidc_provider_arn" {
  value = data.aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = data.aws_iam_openid_connect_provider.eks.url
}
