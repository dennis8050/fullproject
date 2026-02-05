resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      app = "argocd"
      env = var.env
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd-${var.env}"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
 

   # 🔥 THESE SOLVE 90% OF REAL WORLD PROBLEMS
  reuse_values     = true
  force_update     = true
  replace          = true
  cleanup_on_fail  = true
  atomic           = false
  depends_on = [
    kubernetes_namespace_v1.argocd
  ]
  
  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }

        ingress = var.env == "prod" ? {
          enabled          = true
          ingressClassName = "alb"

          annotations = {
            "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
            "alb.ingress.kubernetes.io/target-type" = "ip"
            "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]"
          }

          paths = [
            {
              path     = "/"
              pathType = "Prefix"
            }
          ]
        } : {
          enabled = false
          ingressClassName = ""
          annotations      = {}
          paths            = []
        }
      }
    })
  ]
}
