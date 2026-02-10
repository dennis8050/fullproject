provider "aws" {
  region = var.aws_region
}

# Token only (this is correct)
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Kubernetes provider (USE MODULE OUTPUTS)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
  token                  = data.aws_eks_cluster_auth.this.token

  
}

# Helm provider (USE MODULE OUTPUTS)
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }

 
}