######################################################################
## AWS Load Balancer Controller Pod Identity
######################################################################
resource "aws_iam_policy" "aws_load_balancer_controller_pod_identity" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/templates/alb_policy.json")
}

resource "aws_iam_role" "aws_load_balancer_controller_pod_identity" {
  name               = "kkamji-aws-load-balancer-controller-pod-identity-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_pod_identity" {
  role       = aws_iam_role.aws_load_balancer_controller_pod_identity.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller_pod_identity.arn
}

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller_pod_identity" {
  cluster_name    = aws_eks_cluster.kkamji_cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller-sa"
  role_arn        = aws_iam_role.aws_load_balancer_controller_pod_identity.arn
}

######################################################################
## EBS CSI Driver Pod Identity
######################################################################
resource "aws_iam_role" "ebs_csi_driver_pod_identity" {
  name               = "kkamji-ebs-csi-driver-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_pod_identity" {
  role       = aws_iam_role.ebs_csi_driver_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# 필요 없음 -> addon을 생성하며 pod-identity에 Role을 지정하면 pod_identity_association과 sa가 같이 생성됨
# resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
#   cluster_name    = aws_eks_cluster.kkamji_cluster.name
#   namespace       = kubernetes_service_account.ebs_csi_driver.metadata[0].namespace
#   service_account = kubernetes_service_account.ebs_csi_driver.metadata[0].namespace
#   role_arn        = aws_iam_role.ebs_csi_driver_pod_identity.arn
# }

######################################################################
## External-DNS Pod Identity
######################################################################

resource "aws_iam_role" "external_dns_pod_identity" {
  name               = "kkamji-external-dns-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

resource "aws_iam_policy" "external_dns_pod_identity" {
  name   = "kkamji-external-dns-policy"
  policy = file("${path.module}/templates/external_dns_policy.json")
}

resource "aws_iam_role_policy_attachment" "external_dns_pod_identity" {
  role       = aws_iam_role.external_dns_pod_identity.name
  policy_arn = aws_iam_policy.external_dns_pod_identity.arn
}

resource "aws_eks_pod_identity_association" "external_dns_pod_identity" {
  cluster_name    = aws_eks_cluster.kkamji_cluster.name
  namespace       = "external-dns"
  service_account = "external-dns-sa"
  role_arn        = aws_iam_role.external_dns_pod_identity.arn
}

######################################################################
## External-Secrets Pod Identity
######################################################################

resource "aws_iam_role" "external_secrets_pod_identity" {
  name               = "kkamji-external-secrets-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}


resource "aws_iam_role_policy_attachment" "external_secrets_parameter_store_pod_identity" {
  role       = aws_iam_role.external_secrets_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "external_secrets_secrets_manager_pod_identity" {
  role       = aws_iam_role.external_secrets_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_eks_pod_identity_association" "external_secrets_pod_identity" {
  cluster_name    = aws_eks_cluster.kkamji_cluster.name
  namespace       = "external-secrets"
  service_account = "external-secrets-sa"
  role_arn        = aws_iam_role.external_secrets_pod_identity.arn
}
