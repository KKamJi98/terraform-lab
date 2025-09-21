locals {
  cluster_name = "kkamji-simple"

  # 업그레이드 설정(노드 그룹 공통)
  default_update_config = {
    max_unavailable_percentage = 50
  }

  account_id = data.aws_caller_identity.current.account_id
}

locals {
  cluster_creator_principal_arn = coalesce(
    try(data.aws_iam_session_context.current.issuer_arn, null),
    data.aws_caller_identity.current.arn
  )
}

locals {
  cluster_creator_access_entry = {
    cluster_creator = {
      principal_arn = local.cluster_creator_principal_arn
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

locals {
  pod_identity_source_arn = "arn:${data.aws_partition.current.partition}:eks:${var.region}:${local.account_id}:podidentityassociation/${local.cluster_name}/*"
}

locals {
  ebs_csi_pod_identity_associations = [
    {
      role_arn        = aws_iam_role.ebs_csi_driver.arn
      service_account = "ebs-csi-controller-sa"
      namespace       = "kube-system"
    }
  ]
}

locals {
  external_dns_pod_identity_associations = [
    {
      role_arn        = aws_iam_role.external_dns.arn
      service_account = "external-dns"
      namespace       = "kube-system"
    }
  ]
}
