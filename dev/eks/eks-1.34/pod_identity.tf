locals {
  ebs_csi_driver_role_name               = "EBSCSIDriverRole-${local.cluster_name}"
  aws_load_balancer_controller_role_name = "AwsLoadBalancerControllerRole-${local.cluster_name}"
  aws_load_balancer_controller_policy    = "AWSLoadBalancerControllerPolicy-${local.cluster_name}"
  external_dns_role_name                 = "ExternalDNSRole-${local.cluster_name}"
  external_dns_policy                    = "ExternalDNSPolicy-${local.cluster_name}"

}

###################################################
# EBS CSI Driver IAM Role
###################################################
data "aws_iam_policy_document" "ebs_csi_driver" {
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
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

###################################################
# AWS Load Balancer Controller IAM Role
###################################################
data "aws_iam_policy_document" "aws_load_balancer_controller" {
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
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller.json
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

###################################################
# AWS Load Balancer Controller IAM Role
###################################################
data "aws_iam_policy_document" "external_dns" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "external_dns" {
  name   = local.external_dns_policy
  policy = templatefile("${path.module}/templates/external-dns-policy.json", {})

  tags = local.tags
}

resource "aws_iam_role" "external_dns" {
  name               = local.external_dns_role_name
  assume_role_policy = data.aws_iam_policy_document.external_dns.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "external-dns-sa"
  role_arn        = aws_iam_role.external_dns.arn
}
