terraform {
  required_version = ">= 1.11.0"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.kkamji_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.kkamji_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.kkamji_cluster.token
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.kkamji_cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.kkamji_cluster.certificate_authority[0].data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.kkamji_cluster.name]
#   }
# }
