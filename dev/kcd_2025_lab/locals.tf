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

locals {
  # EBS CSI 드라이버 Pod Identity 매핑을 list(object)로 명시
  ebs_csi_pod_identity_associations_east = [
    {
      role_arn        = aws_iam_role.ebs_csi_driver_pod_identity_east.arn
      service_account = "ebs-csi-controller-sa"
      namespace       = "kube-system"
    }
  ]

  ebs_csi_pod_identity_associations_west = [
    {
      role_arn        = aws_iam_role.ebs_csi_driver_pod_identity_west.arn
      service_account = "ebs-csi-controller-sa"
      namespace       = "kube-system"
    }
  ]
}

locals {
  # external-dns Pod Identity 매핑 (east/west)
  external_dns_pod_identity_associations_east = [
    {
      role_arn        = aws_iam_role.external_dns_pod_identity_east.arn
      service_account = "external-dns"
      namespace       = "kube-system"
    }
  ]

  external_dns_pod_identity_associations_west = [
    {
      role_arn        = aws_iam_role.external_dns_pod_identity_west.arn
      service_account = "external-dns"
      namespace       = "kube-system"
    }
  ]
}
