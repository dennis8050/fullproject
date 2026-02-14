variable "app_name" {
  description = "Name of the application (used for PVC name)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the PVC"
  type        = string
  default     = "monitoring"
}

variable "storage_size" {
  description = "Size of the PVC"
  type        = string
  default     = "10Gi"
}
