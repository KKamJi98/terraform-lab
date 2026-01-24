locals {
  ebs_csi_driver_role_name = "EbsCsiDriverRole-${local.cluster_name}"
}

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
