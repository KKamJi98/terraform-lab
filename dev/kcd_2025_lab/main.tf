# 로컬 변수는 locals.tf로 이동
# Access Entry 관련 로컬 변수는 locals.tf로 이동

module "eks_east" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                = local.cluster_names.east
  kubernetes_version  = "1.33"

  # vpc-cni 사용 + 접두사 할당 활성화, 코어 애드온 추가
  addons = {
    coredns    = {}
    kube-proxy = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    snapshot-controller = {}
  }

  # Optional
  endpoint_public_access = true

  # 내장 부트스트랩 비활성화: 별도의 Access Entry로 관리
  enable_cluster_creator_admin_permissions = false

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # 관리형 노드그룹 (Graviton, t4g.small) - 정확히 2대
  eks_managed_node_groups = {
    east_ng = {
      name            = "east_ng"
      ami_type        = "AL2023_ARM_64_STANDARD"
      instance_types  = ["t4g.small"]
      capacity_type   = "ON_DEMAND"

      min_size     = 2
      max_size     = 2
      desired_size = 2

      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

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

  # Access Entry: 현재 Caller 전역 권한 + 외부 주입값 병합
  access_entries = merge(var.access_entries_east, local.cluster_creator_access_entry)
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
    eks-pod-identity-agent = {
      before_compute = true
    }
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    snapshot-controller = {}
  }

  # Optional
  endpoint_public_access = true

  # 내장 부트스트랩 비활성화: 별도의 Access Entry로 관리
  enable_cluster_creator_admin_permissions = false

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # 관리형 노드그룹 (Graviton, t4g.small) - 정확히 2대
  eks_managed_node_groups = {
    west_ng = {
      name            = "west_ng"
      ami_type        = "AL2023_ARM_64_STANDARD"
      instance_types  = ["t4g.small"]
      capacity_type   = "ON_DEMAND"

      min_size     = 2
      max_size     = 2
      desired_size = 2
      
      # Use SSH key via Launch Template to avoid remote_access conflict
      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

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

  # Access Entry: 현재 Caller 전역 권한 + 외부 주입값 병합
  access_entries = merge(var.access_entries_west, local.cluster_creator_access_entry)
}

# EBS CSI 드라이버용 IRSA (east)
module "ebs_csi_driver_irsa_east" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0"

  name = "ebs-csi-east"

  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks_east.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# EBS CSI 드라이버용 IRSA (west)
module "ebs_csi_driver_irsa_west" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0"

  name = "ebs-csi-west"

  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks_west.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# 순환 종속성 방지를 위해 EBS CSI 애드온은 모듈 밖에서 생성
resource "aws_eks_addon" "ebs_csi_east" {
  cluster_name             = module.eks_east.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_csi_driver_irsa_east.arn
}

resource "aws_eks_addon" "ebs_csi_west" {
  cluster_name             = module.eks_west.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_csi_driver_irsa_west.arn
}
