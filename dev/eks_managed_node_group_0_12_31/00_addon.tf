# 공식 문서 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
# 애드온 이름 확인 aws eks describe-addon-versions --kubernetes-version 1.32 --region ap-northeast-2 --query 'addons[].addonName' --output table
# 애드온 버전 확인 aws eks describe-addon-versions --region ap-northeast-2 --kubernetes-version 1.32 --addon-name vpc-cni --query 'addons[].addonVersions[].addonVersion' --output table
########################################
# VPC-CNI
########################################
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.kkamji_cluster.name
  addon_name   = "vpc-cni"
  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
    }
  })
  # addon_version               = "v1.10.1-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE" # 자체 관리형 애드온을 Amazon EKS 애드온으로 마이그레이션할 때 필드 값 충돌을 어떻게 할건지 (OVERWRITE | NONE(default))
  resolve_conflicts_on_update = "OVERWRITE" # Addon 기본 값을 변경 했을 때 필드 값 충돌을 어떻게 할건지 (OVERWRITE | PRESERVE | NONE(default))
  # pod_identity_association =
  # service_account_role_arn =
}

########################################
# Kube-Proxy
########################################
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.kkamji_cluster.name
  addon_name   = "kube-proxy"
}

########################################
# CoreDNS
########################################
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.kkamji_cluster.name
  addon_name   = "coredns"
}

########################################
# EBS-CSI-driver
########################################
# resource "aws_eks_addon" "ebs_csi_driver" {
#   cluster_name = aws_eks_cluster.kkamji_cluster.name
#   addon_name   = "aws-ebs-csi-driver"
#   pod_identity_association {
#     role_arn        = aws_iam_role.ebs_csi_driver_pod_identity.arn
#     service_account = "ebs-csi-controller-sa"
#     # service_account = aws_eks_pod_identity_association.ebs_csi_driver.service_account
#   }
# }

########################################
# metrics-server
########################################
resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.kkamji_cluster.name
  addon_name   = "metrics-server"
}

