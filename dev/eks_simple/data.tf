data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}


data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
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

data "aws_iam_policy_document" "external_secrets_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:sub"
      values = [
        "system:serviceaccount:external-secrets:external-secrets-irsa"
      ]
    }
    effect = "Allow"
  }
}
