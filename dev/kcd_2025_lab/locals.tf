locals {
  # 클러스터 이름 정의
  cluster_names = {
    east = "kkamji-east"
    west = "kkamji-west"
  }
}

locals {
  # 현재 Caller에게 클러스터 전역 권한(두 정책)을 부여하는 Access Entry
  cluster_creator_access_entry = {
    cluster_creator = {
      principal_arn = data.aws_iam_session_context.current.issuer_arn
      type          = "STANDARD"
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        admin = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

