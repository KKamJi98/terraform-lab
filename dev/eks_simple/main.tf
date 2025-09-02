## Provisioning EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "kkamji-al2023-dev"
  kubernetes_version = "1.32"

  # bootstrap_self_managed_addons = false
  addons = {
    coredns = {}
    # eks-pod-identity-agent = {}
    kube-proxy = {}

    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_driver_irsa.arn
    }
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    snapshot-controller = {}
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = false

  # EKS Access Entry: 명시적으로 관리자 권한 부여 (bootstrap 비활성화 상태)
  access_entries = {
    kkamji_admin = {
      principal_arn = local.access_principal_arn
      policy_associations = {
        # 클러스터 관리자(ClusterAdmin)
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        # 일반 관리자(Admin)
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  eks_managed_node_groups = {
    application = {
      node_group_name = "application"
      ami_type        = "AL2023_ARM_64_STANDARD"
      # ami_type       = "AL2_ARM_64"
      instance_types = ["t4g.small"]
      capacity_type  = "ON_DEMAND" # ON_DEMAND로 해야 Free Tier가 적용됨 SPOT (X)

      min_size     = 2
      max_size     = 3
      desired_size = 2

      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

      update_config = local.default_update_config
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
      labels = {
        "node.kubernetes.io/app" = "operation2"
      }
    }

    operation = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_ARM_64_STANDARD"
      instance_types = ["t4g.small"]
      # capacity_type  = "SPOT"
      capacity_type = "ON_DEMAND" # ON_DEMAND로 해야 Free Tier가 적용됨 SPOT (X)

      min_size     = 2
      max_size     = 3
      desired_size = 2

      key_name      = data.terraform_remote_state.basic.outputs.key_pair_name
      update_config = local.default_update_config
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
      labels = {
        "node.kubernetes.io/app" = "operation"
      }
    }
  }

  # 테스트 용에서만 (실제로는 사용하지 않음) - kms 키는 바로 삭제가 안됨
  encryption_config = {}
}

module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0"

  name = "ebs-csi"

  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
