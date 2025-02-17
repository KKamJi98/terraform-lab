locals {
  default_update_config = {
    max_unavailable_percentage = 50
  }
}

## Provisioning EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.33"

  cluster_name    = "kkamji-al2023-simple"
  cluster_version = "1.32"

  # bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    # amazon-cloudwatch-observability = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids
  # control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "t3.medium", "t4g.small"]
  }

  eks_managed_node_groups = {
    kkamji = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_ARM_64_STANDARD"
      instance_types = ["t4g.small"]
      # capacity_type  = "SPOT"
      capacity_type = "ON_DEMAND" # ON_DEMAND로 해야 Free Tier가 적용됨 SPOT (X)

      min_size     = 1
      max_size     = 3
      desired_size = 1

      key_name      = data.terraform_remote_state.basic.outputs.key_pair_name
      update_config = local.default_update_config
      # cloudinit_pre_nodeadm = [
      #   {
      #     content_type = "application/node.eks.aws"
      #     content      = <<-EOT
      #       ---
      #       apiVersion: node.eks.aws/v1alpha1
      #       kind: NodeConfig
      #       spec:
      #         kubelet:
      #           config:
      #             shutdownGracePeriod: 30s
      #             featureGates:
      #               DisableKubeletCloudCredentialProviders: true
      #     EOT
      #   }
      # ]
    }
  }

  # 테스트 용에서만 (실제로는 사용하지 않음) - kms 키는 바로 삭제가 안됨
  cluster_encryption_config = {}

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
