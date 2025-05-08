######################################################################
## AWS Load Balancer Controller Pod Identity
######################################################################
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["pods.eks.amazonaws.com"]
#     }

#     actions = [
#       "sts:AssumeRole",
#       "sts:TagSession"
#     ]
#   }
# }

resource "aws_iam_policy" "aws_load_balancer_controller_pod_identity" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/templates/alb_policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller_pod_identity.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller_pod_identity.arn
}

resource "aws_iam_role" "aws_load_balancer_controller_pod_identity" {
  name               = "kkamji-aws-load-balancer-controller-pod-identity-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = aws_eks_cluster.kkamji_cluster.name
  namespace       = kubernetes_service_account.aws_load_balancer_controller.metadata[0].namespace
  service_account = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  role_arn        = aws_iam_role.aws_load_balancer_controller_pod_identity.arn
}

######################################################################
## EBS CSI Driver Pod Identity
######################################################################
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_pod_identity" {
  role       = aws_iam_role.ebs_csi_driver_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "ebs_csi_driver_pod_identity" {
  name               = "eks-managed-ebs-csi-driver-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

# 필요 없음 -> addon을 생성하며 pod-identity에 Role을 지정하면 pod_identity_association과 sa가 같이 생성됨
# resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
#   cluster_name    = aws_eks_cluster.kkamji_cluster.name
#   namespace       = kubernetes_service_account.ebs_csi_driver.metadata[0].namespace
#   service_account = kubernetes_service_account.ebs_csi_driver.metadata[0].namespace
#   role_arn        = aws_iam_role.ebs_csi_driver_pod_identity.arn
# }