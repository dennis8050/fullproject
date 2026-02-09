variable "project_name" {}
variable "env" {}
variable "aws_region" {}
variable "aws_account_id" {}
variable "oidc_role_arn" {
  
}
variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "azs" {

}
variable "frontend_repo_name" {}
variable "backend_repo_name" {}

variable "eks_node_type" {}
variable "eks_node_count" {}






variable "sso_instance_arn" {
  type = string
}




variable "sso_client_id" {  }
variable "sso_client_secret" {  }
variable "sso_auth_url" {  }
variable "sso_token_url" {  }
variable "sso_api_url" { }
variable "monitoring_domain" { 
}
variable "ssl_certificate_arn" {
  
}

variable "group_ids" {
  
}

