# -----------------------------
# Namespace for ArgoCD
# -----------------------------
resource "kubernetes_namespace_v1" "argocd" {
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
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"

      # SSL handled by ALB
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/certificate-arn"  = var.ssl_certificate_arn

      # Important for ArgoCD
      "alb.ingress.kubernetes.io/healthcheck-path" = "/healthz"
    }

    hosts = [var.argocd_domain]
    paths = ["/"]
  } : {
    enabled          = false
    ingressClassName = ""
    annotations      = {}
    hosts            = []
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

        # 🔥 THIS FIXES YOUR ISSUE
        extraArgs = ["--insecure"]

        service = {
          type = "LoadBalancer"
        }

        ingress = local.argocd_ingress
      }
    })
  ]
}
