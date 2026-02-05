variable "aws_region" {}
variable "aws_profile" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "eks_node_type" {}
variable "eks_node_count" {}
variable "frontend_repo_name" {}
variable "backend_repo_name" {}
variable "sso_group_arns" {
  type = map(string)
}
