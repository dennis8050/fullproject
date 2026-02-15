# ----------------------------
# Namespace
# ----------------------------

# ----------------------------
# Prometheus + Grafana
# ----------------------------
resource "helm_release" "kube_prometheus" {
  name       = "kube-prometheus-${var.env}"

  namespace  = var.namespace
  create_namespace = true
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "58.5.0"
  timeout    = 900
  force_update = true


  values = [
    yamlencode({
      grafana = {
        service = {
          type = var.env == "prod" ? "LoadBalancer" : "ClusterIP"
        }
        ingress = {
          enabled = false
        }
        ini = var.env == "prod" ? {
          auth = {
            generic_oauth = {
              enabled             = true
              name                = "MySSO"
              allow_sign_up       = true
              client_id           = var.sso_client_id
              client_secret       = var.sso_client_secret
              auth_url            = var.sso_auth_url
              token_url           = var.sso_token_url
              api_url             = var.sso_api_url
              scopes              = "openid profile email"
              role_attribute_path = "contains(groups,'admins') && 'Admin' || 'Viewer'"
            }
          }
        } : {}
      }

      prometheus = {
        prometheusSpec = {
          retention = "7d"
        }
      }
    })
  ]
}


# ----------------------------
# Loki
# ----------------------------
resource "helm_release" "loki" {
  name       = "loki-${var.env}"
  namespace  = var.namespace
  create_namespace = true
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "5.41.0"
  timeout    = 900

  force_update = true
  replace      = true

 values = [
  yamlencode({
    loki = {
      persistence = {
        enabled          = true
        storageClassName = "gp3-loki"
        size             = "10Gi"
        accessModes      = ["ReadWriteOnce"]
      }

      retention_period = "168h" # 7 days

      commonConfig = {
        replication_factor = 1
      }
    }
  })
]


}

# ----------------------------
# Promtail
# ----------------------------
resource "helm_release" "promtail" {
  name       = "promtail-${var.env}"
  namespace  =var.namespace
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.15.5"
  timeout    = 900

  # THIS WILL FORCE HELM TO TAKE OVER EXISTING RESOURCES
  force_update = true
  replace      = true

  values = [
    yamlencode({
      config = {
        clients = [ { url = "http://loki:3100/loki/api/v1/push" } ]
      }
    })
  ]
}

# ----------------------------
# ALB Ingress for Grafana (prod only)
# ----------------------------
resource "kubernetes_ingress_v1" "grafana" {
  count = var.env == "prod" ? 1 : 0

  metadata {
    name      = "grafana-ingress"
    namespace = var.namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"     = jsonencode([{ "HTTP": 80 }, { "HTTPS": 443 }])
      "alb.ingress.kubernetes.io/healthcheck-path" = "/api/health"
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = var.ssl_certificate_arn
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.monitoring_domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-${var.env}-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
