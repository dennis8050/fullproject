# modules/addon/ebs_csi_driver.tf
resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.25.0"
  namespace  = "kube-system"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_attach
  ]

  values = [
    yamlencode({
      controller = {
        serviceAccount = {
          create = true
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = var.ebs_csi_irsa_arn
          }
        }
      }
    })
  ]
}
