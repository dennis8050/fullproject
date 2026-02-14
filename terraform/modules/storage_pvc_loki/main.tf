# ----------------------------
# Namespace for monitoring (optional if not created elsewhere)
# ----------------------------
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# ----------------------------
# StorageClass for Loki
# ----------------------------
resource "kubernetes_storage_class_v1" "gp3_loki" {
  metadata {
    name = "gp3-loki"
  }

  provisioner            = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }
}

# ----------------------------
# PVC for Loki
# ----------------------------
resource "kubernetes_persistent_volume_claim_v1" "app_pvc" {
  metadata {
    name      = "${var.app_name}-pvc"
    namespace = kubernetes_namespace_v1.monitoring.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.storage_size  # e.g., "10Gi"
      }
    }

    storage_class_name = kubernetes_storage_class_v1.gp3_loki.metadata[0].name
  }

  depends_on = [
    kubernetes_storage_class_v1.gp3_loki
  ]
}

# ----------------------------
# Outputs
# ----------------------------
