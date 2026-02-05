variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "node_type" {}
variable "node_count" {}
