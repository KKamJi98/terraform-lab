data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
}