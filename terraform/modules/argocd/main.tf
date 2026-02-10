# -----------------------------
# Namespace for ArgoCD
# -----------------------------
resource "kubernetes_namespace_v1" "argocd" {
  provider = kubernetes.eks
  metadata {
    name = var.namespace
    labels = {
      app = "argocd"
      env = var.env
    }
  }
}

# -----------------------------
# Compute ingress values depending on environment
# -----------------------------
locals {
  argocd_ingress = var.env == "prod" ? {
    enabled          = true
    ingressClassName = "alb"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]"
    }
    # <-- FIX: paths must be a list of strings
    paths = ["/"]
  } : {
    enabled          = false
    ingressClassName = ""
    annotations      = {}
    paths            = []
  }
}

# -----------------------------
# Helm Release for ArgoCD
# -----------------------------
resource "helm_release" "argocd" {
  name       = "argocd-${var.env}"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  # Terraform / Helm best practices
  reuse_values    = true
  force_update    = true
  replace         = true
  cleanup_on_fail = true
  atomic          = false

  depends_on = [
    kubernetes_namespace_v1.argocd
  ]

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
        ingress = local.argocd_ingress
      }
    })
  ]
}
