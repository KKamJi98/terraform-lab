module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "kkamji-cluster"
  cluster_version = "1.31"

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    # instance_types = ["t3.medium", "m5.large", "m5n.large", "m5zn.large"]
    instance_types = ["m7i.large"]
  }

  eks_managed_node_groups = {
    kkamji_nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i.large"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      key_name       = data.terraform_remote_state.basic.outputs.key_pair_name
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}