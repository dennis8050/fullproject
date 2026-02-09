variable "cluster_name" {}
variable "private_subnets" {
  type = list(string)
}
variable "node_type" {}
variable "node_count" {}
variable "aws_region" {}
variable "create_oidc_provider" {
  type    = bool
  default = false
}
