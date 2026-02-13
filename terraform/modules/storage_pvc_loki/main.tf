


resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "monitoring"
  }
}
#pvc for loki
resource "kubernetes_persistent_volume_claim_v1" "app_pvc" {

  metadata {
    name      = "${var.app_name}-pvc"
    namespace =kubernetes_namespace_v1.this.metadata[0].name
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
