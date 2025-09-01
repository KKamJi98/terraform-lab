locals {
  # 업그레이드 설정(노드 그룹 공통)
  default_update_config = {
    max_unavailable_percentage = 50
    # max_unavailable = 3
  }

  # AccessEntry에 사용할 주체 ARN (세션이면 issuer_arn, 아니면 caller ARN)
  access_principal_arn = coalesce(
    try(data.aws_iam_session_context.current.issuer_arn, null),
    data.aws_caller_identity.current.arn
  )

  # IRSA 정책 작성에 필요한 값들
  account_id  = data.aws_caller_identity.current.account_id
  oidc_issuer = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

