output "alb_irsa_arn" {
  value = aws_iam_role.alb_irsa.arn
}

output "argocd_irsa_arn" {
  value = aws_iam_role.argocd_irsa.arn
}

output "ebs_csi_irsa_arn" {
  value = aws_iam_role.ebs_csi_irsa.arn
}
