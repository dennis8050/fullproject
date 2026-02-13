
output "pvc_name" {
  value       = kubernetes_persistent_volume_claim_v1.app_pvc.metadata[0].name
  description = "Name of the Loki PVC"
}
