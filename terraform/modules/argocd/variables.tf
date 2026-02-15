

variable "env" {
  type = string
}

variable "namespace" {
  type    = string
  
}

variable "chart_version" {
  type    = string
  default = "5.43.0"
}
variable "ssl_certificate_arn" {}
variable "argocd_domain" {}
