locals {
  ebs_csi_driver_role_name               = "EbsCsiDriverRole-${local.cluster_name}"
  aws_load_balancer_controller_role_name = "AwsLoadBalancerControllerRole-${local.cluster_name}"
  aws_load_balancer_controller_policy    = "AwsLoadBalancerControllerPolicy-${local.cluster_name}"
}

###################################################
# EBS CSI Driver IAM Role
###################################################
data "aws_iam_policy_document" "ebs_csi_driver_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_driver" {
  name               = local.ebs_csi_driver_role_name
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

###################################################
# AWS Load Balancer Controller IAM Role
###################################################
data "aws_iam_policy_document" "aws_load_balancer_controller_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = local.aws_load_balancer_controller_policy
  policy = templatefile("${path.module}/templates/aws-load-balancer-controller-policy.json", {})

  tags = local.tags
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = local.aws_load_balancer_controller_role_name
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller-sa"
  role_arn        = aws_iam_role.aws_load_balancer_controller.arn
}
