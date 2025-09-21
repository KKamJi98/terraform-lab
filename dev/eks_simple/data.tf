data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_iam_policy_document" "external_secrets" {
  # SSM Parameter Store 접근 정책
  statement {
    sid = "SSMParameterStoreAccess"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:DescribeParameters"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/*"
    ]
  }

  # Secrets Manager 접근 정책
  statement {
    sid = "SecretsManagerReadAccess"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${local.account_id}:secret:*"
    ]
  }

  statement {
    sid = "SecretsManagerListAndPolicy"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}

data "aws_vpc" "this" {
  id = data.terraform_remote_state.basic.outputs.vpc_id
}
