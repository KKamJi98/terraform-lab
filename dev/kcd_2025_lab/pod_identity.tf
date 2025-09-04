###############################################
# Pod Identity for EBS CSI (east / west)
###############################################

# EBS CSI용 IAM Role (east)
resource "aws_iam_role" "ebs_csi_driver_pod_identity_east" {
  name = "kkamji-ebs-csi-driver-role-east"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    account_id   = data.aws_caller_identity.current.account_id
    partition    = data.aws_partition.current.partition
    region       = var.region
    cluster_name = local.cluster_names.east
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_pod_identity_east" {
  role       = aws_iam_role.ebs_csi_driver_pod_identity_east.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# EBS CSI용 IAM Role (west)
resource "aws_iam_role" "ebs_csi_driver_pod_identity_west" {
  name = "kkamji-ebs-csi-driver-role-west"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    account_id   = data.aws_caller_identity.current.account_id
    partition    = data.aws_partition.current.partition
    region       = var.region
    cluster_name = local.cluster_names.west
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_pod_identity_west" {
  role       = aws_iam_role.ebs_csi_driver_pod_identity_west.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

###############################################
# Pod Identity for ExternalDNS (east / west)
###############################################

# 공용 external-dns 정책 (Route53)
data "aws_partition" "this" {}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "kkamji-external-dns-policy"
  description = "Permissions for ExternalDNS to manage Route53 records"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:route53:::hostedzone/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ListHostedZonesByName",
          "route53:ListTagsForResource"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# external-dns IAM Role (east)
resource "aws_iam_role" "external_dns_pod_identity_east" {
  name = "kkamji-external-dns-role-east"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    account_id   = data.aws_caller_identity.current.account_id
    partition    = data.aws_partition.current.partition
    region       = var.region
    cluster_name = local.cluster_names.east
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attach_east" {
  role       = aws_iam_role.external_dns_pod_identity_east.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

# external-dns IAM Role (west)
resource "aws_iam_role" "external_dns_pod_identity_west" {
  name = "kkamji-external-dns-role-west"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    account_id   = data.aws_caller_identity.current.account_id
    partition    = data.aws_partition.current.partition
    region       = var.region
    cluster_name = local.cluster_names.west
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attach_west" {
  role       = aws_iam_role.external_dns_pod_identity_west.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}
