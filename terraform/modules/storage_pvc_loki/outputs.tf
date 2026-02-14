output "pvc_name" {
  value = kubernetes_persistent_volume_claim_v1.app_pvc.metadata[0].name
}

output "storage_class_name" {
  value = kubernetes_storage_class_v1.gp3_loki.metadata[0].name
}
