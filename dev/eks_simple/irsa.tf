###############################################################
# Policy (locals는 locals.tf로 이동)
###############################################################

 

###############################################################
# IAM Role
###############################################################
resource "aws_iam_role" "external_secrets" {
  name               = "kkamji_external_secrets"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume.json
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

###############################################################
# Managed Policy
###############################################################
resource "aws_iam_policy" "external_secrets_policy" {
  name        = "kkamji_external_secrets_policy"
  description = "Policy for External Secrets to access SSM Parameter Store and Secrets Manager"
  policy      = data.aws_iam_policy_document.external_secrets.json
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

###############################################################
# IAM Role Policy Attachment
###############################################################
resource "aws_iam_role_policy_attachment" "external_secrets_policy_attachment" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

#############################
# Kubernetes Namespace 생성 (IRSA)
#############################

resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
  # EKS 클러스터 및 접근 제어가 준비된 뒤 생성되도록 보장
  depends_on = [
    module.eks
  ]
}

#############################
# Kubernetes ServiceAccount 생성 (IRSA)
#############################

resource "kubernetes_service_account" "external_secrets_irsa" {
  metadata {
    name      = "external-secrets-irsa"
    namespace = kubernetes_namespace.external_secrets.metadata[0].name
    annotations = {
      # IRSA IAM 역할의 ARN을 동적으로 참조합니다.
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets.arn
    }
  }
  depends_on = [
    module.eks
  ]
}
