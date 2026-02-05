output "role_arn" {
  value = aws_iam_role.github_actions.arn
  description = "ARN of GitHub Actions IAM role"
}
