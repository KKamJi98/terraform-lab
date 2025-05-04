########################################
# KMS for EKS Encryption CMK(Customer Managed Keys) & Alias
########################################

locals {
  eks_secrets_policy = templatefile(
    "${path.module}/templates/eks_encryption_kms_policy.json",
    {
      account_id       = data.aws_caller_identity.current.account_id
      cluster_role_arn = aws_iam_role.kkamji_cluster.arn
      region           = var.region
    }
  )
}

resource "aws_kms_key" "eks_encryption" {
  description             = "CMK for EKS secrets encryption"
  deletion_window_in_days = 7
  policy                  = local.eks_secrets_policy
  enable_key_rotation = true
}

resource "aws_kms_alias" "eks_encryption_alias" {
  name          = "alias/kkamji-eks-cluster-encryption"
  target_key_id = aws_kms_key.eks_encryption.key_id
}