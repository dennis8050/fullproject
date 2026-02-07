resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-${var.env}-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(

      # ----- 1. Local test user (keep as is) -----
      [
        {
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${var.aws_account_id}:user/testuser"
          }
          Action = "sts:AssumeRole"
        }
      ],

      # ----- 2. GitHub OIDC - ONLY for stage & prod -----
      var.env == "dev" ? [] : [
        {
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
          }

          Action = "sts:AssumeRoleWithWebIdentity"

          Condition = {
            StringLike = {
              "token.actions.githubusercontent.com:sub" = var.env == "prod" ? 
                "repo:${var.github_repo}:ref:refs/heads/main" :
                "repo:${var.github_repo}:ref:refs/heads/stage"
            }
          }
        }
      ]
    )
  })

  tags = {
    Name = "${var.project_name}-${var.env}-github-actions"
  }
}
