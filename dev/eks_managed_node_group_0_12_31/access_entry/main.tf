module "access_entry" {
  source = "../../../modules/access_entry"

  region       = var.region
  cluster_name = data.terraform_remote_state.cluster.outputs.cluster_name

  access_entries = {
    platform_admin = {
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/KKamJi2024"
      kubernetes_groups = null
      type              = "STANDARD"

      user_name = null
      tags      = {}

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = null
            type       = "cluster" # 전체 클러스터 권한
          }
        }
      }
    },
    platform_ops = {
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/external-secrets"
      kubernetes_groups = ["admin-user-group"]
      type              = "STANDARD"

      user_name = null
      tags      = {}

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          access_scope = {
            namespaces = null
            type       = "cluster" # 전체 클러스터 권한
          }
        }
      }
    }
  }
}
