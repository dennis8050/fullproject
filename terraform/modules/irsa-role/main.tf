# Fetch EKS cluster details
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# Fetch cluster auth token (optional, only if you need kubernetes provider later)
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Fetch TLS certificate of the OIDC issuer to get thumbprint
data "tls_certificate" "eks_thumbprint" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Create OIDC provider for IRSA
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_thumbprint.certificates[0].sha1_fingerprint]
  url             = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}

# Create IRSA role for ALB ingress (example)
resource "aws_iam_role" "irsa_ingress" {
  name = "${var.cluster_name}-ingress-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.oidc.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.cluster.name, "-", "_")}:sub" = "system:serviceaccount:kube-system:alb-ingress-controller"
        }
      }
    }]
  })
}
resource "aws_iam_role" "argocd_irsa" {
  name = "${var.cluster_name}-${var.env}-argocd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" =
          "system:serviceaccount:argocd:argocd-server"
        }
      }
    }]
  })

  tags = {
    Name = "${var.cluster_name}-${var.env}-argocd-irsa"
  }
}

