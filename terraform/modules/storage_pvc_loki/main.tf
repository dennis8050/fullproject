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

  storage_provisioner     = "ebs.csi.aws.com"
  volume_binding_mode     = "Immediate"
  reclaim_policy          = "Delete"
  allow_volume_expansion  = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }
}

# ----------------------------
# PVC for Loki
# ----------------------------

# ----------------------------
# Outputs
# ----------------------------
