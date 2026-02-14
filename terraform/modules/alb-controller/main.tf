variable "cluster_name" {}
variable "region" {}
variable "vpc_id" {}
variable "alb_irsa_role_arn" {}

# ----------------------------
# Service Account
# ----------------------------
resource "kubernetes_service_account_v1" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_irsa_role_arn
    }
  }
}

# ----------------------------
# Helm Install
# ----------------------------
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.15.0"  # pin to a stable version

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account_v1.alb_sa.metadata[0].name
    }
  ]

  depends_on = [
    kubernetes_service_account_v1.alb_sa
  ]
}
