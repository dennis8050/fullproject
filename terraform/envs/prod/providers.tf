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
##########################################################
# AWS Provider
##########################################################
provider "aws" {
  region = var.aws_region
}

##########################################################
# Kubernetes Provider
# Uses outputs from the EKS module
##########################################################
provider "kubernetes" {
  alias = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
  token                  = module.eks.cluster_token
   
}

##########################################################
# Helm Provider
# Uses same Kubernetes provider 
########################################################## note  module.eks.cluster_token uses the outputs.tf to send data to this provider
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
    token                  = module.eks.cluster_token
  }
}
