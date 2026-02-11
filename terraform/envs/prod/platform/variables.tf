variable "project_name" { type = string }
variable "env"          { type = string }
variable "aws_region"   { type = string }

variable "frontend_repo_name" { type = string }
variable "backend_repo_name"  { type = string }

variable "monitoring_domain" {
  type = string
}

variable "ssl_certificate_arn" {
  type = string
}

variable "sso_instance_arn" {
  type = string
}

variable "sso_client_id" {
  type = string
}

variable "sso_client_secret" {
  type      = string
  sensitive = true
}

variable "sso_auth_url"  { type = string }
variable "sso_token_url" { type = string }
variable "sso_api_url"   { type = string }

variable "group_ids" {
  type = list(string)
}
