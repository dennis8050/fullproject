
variable "storage_class_name" {
  description = "Name of the storage class"
  type        = string
}

variable "app_name" {
  description = "Application name to prefix PVC"
  type        = string
}

variable "storage_size" {
  description = "Size of the PVC"
  type        = string
}
