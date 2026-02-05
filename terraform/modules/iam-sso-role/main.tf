# -----------------------------
# Attach Managed Policies to Permission Sets
# -----------------------------
resource "aws_ssoadmin_managed_policy_attachment" "policy_attachments" {
  for_each = {
    for item in flatten([
      for group, cfg in var.group_policies : [
        for policy in cfg.managed_policy_arns : {
          key                = "${group}-${policy}"
          permission_set_arn = cfg.permission_set_arn
          policy_arn         = policy
        }
      ]
    ]) : item.key => item
  }

  instance_arn       = var.sso_instance_arn
  permission_set_arn = each.value.permission_set_arn
  managed_policy_arn = each.value.policy_arn
}

# -----------------------------
# Assign Groups to AWS Account
# -----------------------------
resource "aws_ssoadmin_account_assignment" "assignment" {
  for_each = var.group_assignments

  instance_arn       = var.sso_instance_arn
  permission_set_arn = each.value.permission_set_arn

  principal_type = "GROUP"
  principal_id   = each.value.group_id

  target_id   = var.aws_account_id
  target_type = "AWS_ACCOUNT"
}
