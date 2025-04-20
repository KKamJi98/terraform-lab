######################################################################
## EKS Cluster
######################################################################
resource "aws_eks_cluster" "kkamji_cluster" {
  name = "kkamji-al2023"

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false # 클러스터를 생성한 IAM 사용자 또는 역할에게 자동으로 Kubernetes 클러스터에 대한 전체 관리 권한(admin)을 부여할지 여부 (false로 설정하면, 사용자 또는 역할에게 IAM 정책을 직접 부여해야 함)
  }

  role_arn = aws_iam_role.kkamji_cluster.arn
  version  = "1.32"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.public_access_cidrs
    subnet_ids              = data.terraform_remote_state.basic.outputs.public_subnet_ids
    # cluster_security_group_id = aws_security_group.eks_cluster_sg.id  # 지정 불가
    # security_group_ids = [
    #   # aws_security_group.eks_cluster_sg.id,
    #   aws_security_group.eks_node_sg.id
    # ]
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"
  }

  depends_on = [
    aws_iam_role_policy_attachment.kkamji_cluster,
  ]
}