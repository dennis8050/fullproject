variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "env" {
  type        = string
  description = "Environment: dev, stage, prod"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in format org/repo"
}

variable "github_branch" {
  type        = string
  description = "Branch name allowed to assume the role for this environment"
}
