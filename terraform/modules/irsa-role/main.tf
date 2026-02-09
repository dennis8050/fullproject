############################################
# Fetch EKS Cluster
############################################
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

############################################
# Fetch OIDC TLS Thumbprint
############################################
data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

############################################
# Create OIDC Provider (IRSA)
############################################
resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

############################################
# Shared Local (OIDC URL without https://)
############################################
locals {
  oidc_provider_url = replace(
    aws_iam_openid_connect_provider.eks.url,
    "https://",
    ""
  )
}

############################################
# IRSA: AWS Load Balancer Controller
############################################
resource "aws_iam_role" "alb_irsa" {
  name = "${var.cluster_name}-alb-irsa"

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
          "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

############################################
# IRSA: ArgoCD
############################################
resource "aws_iam_role" "argocd_irsa" {
  name = "${var.cluster_name}-${var.env}-argocd-irsa"

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
          "${local.oidc_provider_url}:sub" ="system:serviceaccount:argocd:argocd-server"
        }
      }
    }]
  })
}

############################################
# IRSA: EBS CSI Driver
############################################
resource "aws_iam_role" "ebs_csi_irsa" {
  name = "${var.cluster_name}-ebs-csi-irsa"

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
          "${local.oidc_provider_url}:sub" ="system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.ebs_csi_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
