variable "aws_account_id" {
  type        = string
  description = "12-digit AWS account ID"
}

variable "sso_instance_arn" {
  type        = string
  description = "AWS SSO Instance ARN"
}

variable "group_policies" {
  type = map(object({
    permission_set_arn  : string
    managed_policy_arns : list(string)
  }))
  description = "Map of groups to permission sets and their managed policies"
}

variable "group_assignments" {
  type = map(object({
    group_id           : string  # UUID of SSO group
    permission_set_arn : string
  }))
  description = "Map of SSO groups to assign to AWS accounts"
}
