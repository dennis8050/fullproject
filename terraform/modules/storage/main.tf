

resource "kubernetes_persistent_volume_claim" "app_pvc" {
  metadata {
    name      = "${var.app_name}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class_name
  }
}
