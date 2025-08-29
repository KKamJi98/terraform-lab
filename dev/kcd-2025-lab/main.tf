locals {
  cluster_names = {
    east = "kkamji-east"
    west = "kkamji-west"
  }
}

module "eks_east" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                = local.cluster_names.east
  kubernetes_version  = "1.33"

  # vpc-cni 사용 + 접두사 할당 활성화, 코어 애드온 추가
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # 관리형 노드그룹 (Graviton, t4g.small) - 정확히 2대
  eks_managed_node_groups = {
    default = {
      name            = "default"
      ami_type        = "AL2023_ARM_64_STANDARD"
      instance_types  = ["t4g.small"]
      capacity_type   = "ON_DEMAND"

      min_size     = 2
      max_size     = 2
      desired_size = 2

      remote_access = {
        ec2_ssh_key = data.terraform_remote_state.basic.outputs.key_pair_name
      }

      enable_bootstrap_user_data = true
      cloudinit_pre_nodeadm = [
        {
          content_type = "application/node.eks.aws"
          content      = <<-EOT
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  maxPods: 110
          EOT
        }
      ]
    }
  }
}

module "eks_west" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_names.west
  kubernetes_version = "1.33"

  # vpc-cni 사용 + 접두사 할당 활성화, 코어 애드온 추가
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # 관리형 노드그룹 (Graviton, t4g.small) - 정확히 2대
  eks_managed_node_groups = {
    default = {
      name            = "default"
      ami_type        = "AL2023_ARM_64_STANDARD"
      instance_types  = ["t4g.small"]
      capacity_type   = "ON_DEMAND"

      min_size     = 2
      max_size     = 2
      desired_size = 2

      remote_access = {
        ec2_ssh_key = data.terraform_remote_state.basic.outputs.key_pair_name
      }

      enable_bootstrap_user_data = true
      cloudinit_pre_nodeadm = [
        {
          content_type = "application/node.eks.aws"
          content      = <<-EOT
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  maxPods: 110
          EOT
        }
      ]
    }
  }
}
