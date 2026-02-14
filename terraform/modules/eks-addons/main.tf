resource "aws_eks_addon" "ebs_csi" {

  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  service_account_role_arn = var.ebs_csi_role_arn

  depends_on = [
    var.ebs_csi_role_arn
  ]
}
