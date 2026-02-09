variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "node_type" {}
variable "node_count" {}

#below help incase oidc exit it skip
variable "create_oidc_provider" {
  type    = bool
  default = false
}
variable "aws_region" {
  
}