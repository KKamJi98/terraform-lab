######################################################################
## Terraform Remote State Data Source
######################################################################
data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "kkamji-lab"
    workspaces = {
      name = "basic"
    }
  }
}

######################################################################
## Current AWS Account ID
######################################################################
data "aws_caller_identity" "current" {}

######################################################################
## EKS Cluster Data
######################################################################

data "aws_eks_cluster" "kkamji_cluster" {
  name = aws_eks_cluster.kkamji_cluster.name
}

data "aws_eks_cluster_auth" "kkamji_cluster" {
  name = aws_eks_cluster.kkamji_cluster.name
}