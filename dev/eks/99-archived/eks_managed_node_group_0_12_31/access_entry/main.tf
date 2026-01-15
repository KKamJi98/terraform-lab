locals {
  access_entry_examples = {
    platform_admin = {
      enabled = true
      config = {
        # 예시: 플랫폼 관리자 전용 IAM 사용자
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/KKamJi2024"
        kubernetes_groups = ["platform-admins"]
        type              = "STANDARD"

        user_name = null
        tags = {
          team = "platform-admin"
        }

        policy_associations = {
          cluster_admin = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              namespaces = null
              type       = "cluster" # 전체 클러스터 권한
            }
          }
        }
      }
    },
    platform_ops = {
      enabled = true
      config = {
        # 예시: 플랫폼 운영팀에 할당된 IAM 사용자
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/external-secrets"
        kubernetes_groups = ["platform-ops"]
        type              = "STANDARD"

        user_name = null
        tags = {
          team = "platform-ops"
        }

        policy_associations = {
          workload_namespace_editor = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
            access_scope = {
              namespaces = ["operations", "monitoring"]
              type       = "namespace" # 특정 네임스페이스 권한
            }
          }
        }
      }
    },
    platform_readonly = {
      enabled = true # IAM 역할 생성 후 true로 전환
      config = {
        # 예시: 감사를 위한 읽기 전용 역할
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kkamji-eks-viewer"
        kubernetes_groups = ["platform-readonly"]
        type              = "STANDARD"

        user_name = null
        tags = {
          team = "platform-audit"
        }

        policy_associations = {
          cluster_view = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
            access_scope = {
              namespaces = null
              type       = "cluster" # 전체 클러스터 권한
            }
          }
        }
      }
    },
    cicd_deployer = {
      enabled = false # CI/CD용 역할 준비 후 true로 전환
      config = {
        # 예시: CI/CD 파이프라인에서 사용할 IAM 역할
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-platform-deployer"
        kubernetes_groups = ["platform-admins", "platform-ops"]
        type              = "STANDARD"

        user_name = null
        tags = {
          team = "platform-cicd"
        }

        policy_associations = {
          deployer_admin = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
            access_scope = {
              namespaces = null
              type       = "cluster"
            }
          }
        }
      }
    },
    managed_node_group = {
      enabled = false # EKS가 자동 생성하므로 import 또는 true 전환 전 중복 확인
      config = {
        # 예시: EKS 노드 그룹 역할
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-managed-node-group-role"
        kubernetes_groups = null
        type              = "EC2_LINUX"

        user_name = null
        tags = {
          "eks/aws:nodegroup" = "operation-custom"
        }

        policy_associations = {}
      }
    },
    self_managed_node_group = {
      enabled = false # IAM 역할 생성 후 true로 전환
      config = {
        # 예시: 셀프 매니지드 노드 그룹(ASG 기반) 역할
        principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-self-managed-node-role"
        kubernetes_groups = null
        type              = "EC2_LINUX"

        user_name = null
        tags = {
          "eks/aws:nodegroup" = "self-managed-operation"
        }

        policy_associations = {}
      }
    }
  }

  access_entries = {
    for key, entry in local.access_entry_examples :
    key => entry.config if try(entry.enabled, true)
  }
}

module "access_entry" {
  source = "../../../modules/access_entry"

  region       = var.region
  cluster_name = data.terraform_remote_state.cluster.outputs.cluster_name

  access_entries = local.access_entries
}
