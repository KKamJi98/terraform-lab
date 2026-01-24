locals {
  karpenter_namespace       = "kube-system"
  karpenter_service_account = "karpenter"

  karpenter_node_role_name       = "KarpenterNodeRole-${local.cluster_name}"
  karpenter_controller_role_name = "KarpenterControllerRole-${local.cluster_name}"
  karpenter_controller_policy    = "KarpenterControllerPolicy-${local.cluster_name}"
}

resource "aws_iam_role" "karpenter_node" {
  name = local.karpenter_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

locals {
  karpenter_node_policies = toset([
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ])
}

resource "aws_iam_role_policy_attachment" "karpenter_node" {
  for_each = local.karpenter_node_policies

  role       = aws_iam_role.karpenter_node.name
  policy_arn = each.value
}

resource "aws_sqs_queue" "karpenter_interruption" {
  name                      = local.cluster_name
  message_retention_seconds = 300
  sqs_managed_sse_enabled   = true

  tags = local.tags
}

data "aws_iam_policy_document" "karpenter_interruption_queue" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.karpenter_interruption.arn,
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }

  statement {
    sid    = "DenyHTTP"
    effect = "Deny"

    actions = ["sqs:*"]
    resources = [
      aws_sqs_queue.karpenter_interruption.arn,
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_sqs_queue_policy" "karpenter_interruption" {
  queue_url = aws_sqs_queue.karpenter_interruption.id
  policy    = data.aws_iam_policy_document.karpenter_interruption_queue.json
}

resource "aws_cloudwatch_event_rule" "karpenter_scheduled_change" {
  name = "${local.cluster_name}-scheduled-change"

  event_pattern = jsonencode({
    source      = ["aws.health"],
    detail-type = ["AWS Health Event"],
  })

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "karpenter_scheduled_change" {
  rule = aws_cloudwatch_event_rule.karpenter_scheduled_change.name
  arn  = aws_sqs_queue.karpenter_interruption.arn
}

resource "aws_cloudwatch_event_rule" "karpenter_spot_interruption" {
  name = "${local.cluster_name}-spot-interruption"

  event_pattern = jsonencode({
    source      = ["aws.ec2"],
    detail-type = ["EC2 Spot Instance Interruption Warning"],
  })

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "karpenter_spot_interruption" {
  rule = aws_cloudwatch_event_rule.karpenter_spot_interruption.name
  arn  = aws_sqs_queue.karpenter_interruption.arn
}

resource "aws_cloudwatch_event_rule" "karpenter_rebalance" {
  name = "${local.cluster_name}-rebalance"

  event_pattern = jsonencode({
    source      = ["aws.ec2"],
    detail-type = ["EC2 Instance Rebalance Recommendation"],
  })

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "karpenter_rebalance" {
  rule = aws_cloudwatch_event_rule.karpenter_rebalance.name
  arn  = aws_sqs_queue.karpenter_interruption.arn
}

resource "aws_cloudwatch_event_rule" "karpenter_instance_state_change" {
  name = "${local.cluster_name}-instance-state-change"

  event_pattern = jsonencode({
    source      = ["aws.ec2"],
    detail-type = ["EC2 Instance State-change Notification"],
  })

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "karpenter_instance_state_change" {
  rule = aws_cloudwatch_event_rule.karpenter_instance_state_change.name
  arn  = aws_sqs_queue.karpenter_interruption.arn
}

resource "aws_iam_policy" "karpenter_controller" {
  name = local.karpenter_controller_policy
  policy = templatefile("${path.module}/templates/karpenter-controller-policy.json.tftpl", {
    partition              = data.aws_partition.current.partition
    region                 = data.aws_region.current.region
    account_id             = data.aws_caller_identity.current.account_id
    cluster_name           = local.cluster_name
    interruption_queue_arn = aws_sqs_queue.karpenter_interruption.arn
    node_role_arn          = aws_iam_role.karpenter_node.arn
  })

  tags = local.tags
}

data "aws_iam_policy_document" "karpenter_controller_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  name               = local.karpenter_controller_role_name
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "karpenter_controller" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}

resource "aws_eks_pod_identity_association" "karpenter_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = local.karpenter_namespace
  service_account = local.karpenter_service_account
  role_arn        = aws_iam_role.karpenter_controller.arn

  depends_on = [module.eks]
}
