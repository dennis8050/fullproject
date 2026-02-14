# ----------------------------
# Namespace for monitoring
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

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "Immediate"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }
}

# ----------------------------
# Loki PVCs (one per backend/write pod)
# ----------------------------
locals {
  loki_backend_count = 3
  loki_write_count   = 3
}

# Backend PVCs
resource "kubernetes_persistent_volume_claim_v1" "loki_backend" {
  for_each = { for i in range(local.loki_backend_count) : i => i }

  metadata {
    name      = "data-loki-backend-${each.key}"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = kubernetes_storage_class_v1.gp3_loki.metadata[0].name
  }

  depends_on = [
    kubernetes_storage_class_v1.gp3_loki
  ]
}

# Write PVCs
resource "kubernetes_persistent_volume_claim_v1" "loki_write" {
  for_each = { for i in range(local.loki_write_count) : i => i }

  metadata {
    name      = "data-loki-write-${each.key}"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = kubernetes_storage_class_v1.gp3_loki.metadata[0].name
  }

  depends_on = [
    kubernetes_storage_class_v1.gp3_loki
  ]
}
