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

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/templates/alb_policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller_pod_identity.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

resource "aws_iam_role" "aws_load_balancer_controller_pod_identity" {
  name               = "kkamji-aws-load-balancer-controller-pod-identity-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}

######################################################################
## EBS CSI Driver Pod Identity
######################################################################
resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "ebs_csi_driver" {
  name               = "eks-managed-ebs-csi-driver-role"
  assume_role_policy = file("${path.module}/templates/pod_identity_assume_role_policy.json")
}
