############################################
# Locals
############################################
locals {
  oidc_provider_url = replace(var.oidc_provider_url, "https://", "")
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
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${local.oidc_provider_url}:sub" ="system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "alb_irsa_attach" {
  role       = aws_iam_role.alb_irsa.name
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/AWSLoadBalancerControllerIAMPolicy"
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
        Federated = var.oidc_provider_arn
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
        Federated = var.oidc_provider_arn
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
