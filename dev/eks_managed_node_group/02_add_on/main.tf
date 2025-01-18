###########################################################################################
## Addon: vpc-cni
###########################################################################################

data "aws_eks_addon_version" "vpc-cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = data.terraform_remote_state.cluster.outputs.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = data.terraform_remote_state.cluster.outputs.cluster_name
  addon_name                  = "vpc-cni"
  addon_version               = data.aws_eks_addon_version.vpc-cni.version
  resolve_conflicts_on_update = "OVERWRITE"
}

###########################################################################################
## Addon: kube-proxy
###########################################################################################

data "aws_eks_addon_version" "kube-proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = data.terraform_remote_state.cluster.outputs.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = data.terraform_remote_state.cluster.outputs.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = data.aws_eks_addon_version.kube-proxy.version
  resolve_conflicts_on_update = "OVERWRITE"
}

###########################################################################################
## Addon: coredns
###########################################################################################


data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = data.terraform_remote_state.cluster.outputs.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = data.terraform_remote_state.cluster.outputs.cluster_name
  addon_name                  = "coredns"
  addon_version               = data.aws_eks_addon_version.coredns.version
  resolve_conflicts_on_update = "OVERWRITE"
}

###########################################################################################
## Addon: eks-pod-identity
###########################################################################################

data "aws_eks_addon_version" "eks-pod-identity-agent" {
  addon_name         = "eks-pod-identity"
  kubernetes_version = data.terraform_remote_state.cluster.outputs.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name                = data.terraform_remote_state.cluster.outputs.cluster_name
  addon_name                  = "eks-pod-identity"
  addon_version               = data.aws_eks_addon_version.eks-pod-identity.version
  resolve_conflicts_on_update = "OVERWRITE"
}

