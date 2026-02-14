variable "env" { type = string }
variable "namespace" { type = string }

# Prod only
variable "monitoring_domain" { type = string }
variable "ssl_certificate_arn" { type = string }

# Prod only SSO
variable "sso_client_id" { type = string }
variable "sso_client_secret" { type = string }
variable "sso_auth_url" { type = string }
variable "sso_token_url" { type = string }
variable "sso_api_url" { type = string }


