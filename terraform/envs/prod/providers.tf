terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.31.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
  }

  required_version = ">= 1.14.4"
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------
# Data sources for EKS cluster
# -----------------------------
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# -----------------------------
# Kubernetes provider
# -----------------------------
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# -----------------------------
# Helm provider
# -----------------------------
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
