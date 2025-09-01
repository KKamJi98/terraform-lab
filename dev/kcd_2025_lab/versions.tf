terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Provider configurations (migrated from providers.tf)
provider "aws" {
  region = var.region
}

# Kubernetes providers per cluster (east / west)
provider "kubernetes" {
  alias                  = "east"
  host                   = module.eks_east.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_east.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_east.cluster_name]
  }
}

provider "kubernetes" {
  alias                  = "west"
  host                   = module.eks_west.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_west.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_west.cluster_name]
  }
}

# Helm providers per cluster (east / west)
provider "helm" {
  alias = "east"
  kubernetes {
    host                   = module.eks_east.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_east.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_east.cluster_name]
    }
  }
}

provider "helm" {
  alias = "west"
  kubernetes {
    host                   = module.eks_west.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_west.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_west.cluster_name]
    }
  }
}
