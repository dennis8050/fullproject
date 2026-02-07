resource "aws_iam_role" "github_actions" {
  name = "userRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"
        }
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.env}-github-actions"
  }
}

# Example minimal policy — adjust per environment
resource "aws_iam_policy" "github_actions_policy" {
  name = "${var.project_name}-${var.env}-github-actions-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "sts:AssumeRole",
          "iam:PassRole",
          "s3:GetObject",
          "s3:PutObject",
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
