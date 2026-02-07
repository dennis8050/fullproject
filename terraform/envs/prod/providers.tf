provider "aws" {
  region = var.aws_region
   # Use OIDC from GitHub Actions
  assume_role {
    role_arn     = var.github_oidc_role_arn
    session_name = "github-actions"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
