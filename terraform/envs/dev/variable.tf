variable "cluster_role_arn" {
  type = string
  default = "arn:aws:iam::123456789012:role/EKSClusterRole"
}

variable "node_role_arn" {
  type = string
  default = "arn:aws:iam::123456789012:role/EKSNodeGroupRole"
}
