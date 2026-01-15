locals {
  name      = "kkamji-al2023"
  namespace = "karpenter"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.36"

  cluster_name    = local.name
  cluster_version = "1.33"

  # bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    eks-pod-identity-agent = {}
    aws-ebs-csi-driver     = {}
    snapshot-controller    = {}
    # metrics-server         = {}
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
    instance_types = ["m6i.large", "t3.medium", "t4g.small"]
  }


  eks_managed_node_groups = {
    karpenter = {
      node_group_name = "application"
      ami_type        = "AL2023_ARM_64_STANDARD"
      # ami_type       = "AL2_ARM_64"
      instance_types = ["t4g.small"]
      capacity_type  = "ON_DEMAND" # ON_DEMAND로 해야 Free Tier가 적용됨 SPOT (X)

      min_size     = 2
      max_size     = 5
      desired_size = 2

      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

      update_config = {
        # max_unavailable = 1
        max_unavailable_percentage = 50
      }

      labels = {
        "karpenter.sh/controller" = "true"
      }

      enable_bootstrap_user_data = true # NodeConfig 파트 자동 생성
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

  node_security_group_tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
  }

  cluster_encryption_config = {}
}

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = module.eks.cluster_name # local 변수 재사용하려 했으나 암묵적 의존관계가 깨져. depends_on을 추가로 설정 해줘야 하는 이슈 발생

  node_iam_role_use_name_prefix = false
  node_iam_role_name            = "kkamji-al2023-KarpenterNodeRole"

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  create_pod_identity_association = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


