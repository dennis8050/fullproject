output "pvc_name" {
  value = kubernetes_persistent_volume_claim.app_pvc.metadata[0].name
}
