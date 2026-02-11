variable "project_name" { type = string }
variable "env"          { type = string }
variable "aws_region"   { type = string }
variable "aws_account_id" { type = string }

variable "vpc_cidr" { type = string }

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "eks_node_type" {
  type = string
}

variable "eks_node_count" {
  type = number
}

variable "create_oidc_provider" {
  type    = bool
  default = true
}
