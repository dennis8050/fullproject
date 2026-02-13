#below is aws storage class for loki
resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = "gp3"
  }

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  allow_volume_expansion = true
}



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
