# modules/addon/variables.tf
variable "ebs_csi_irsa_arn" {
  type        = string
  description = "IAM role ARN for EBS CSI driver service account"
}
