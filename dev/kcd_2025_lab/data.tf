# 현재 Caller의 파티션/ARN/세션 정보 (Access Entry principal_arn 계산용)
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}
