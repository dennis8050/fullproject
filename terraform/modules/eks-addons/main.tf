# EKS addons
resource "aws_iam_role" "sso_roles" {
  for_each = var.sso_group_arns
  name     = "sso-${each.key}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        AWS = each.value
      }
    }]
  })
}
