######################################################################
## IAM for EKS Cluster Access Entry (IAM User 기준)
######################################################################

resource "aws_eks_access_policy_association" "kkamji_cluster_admin" {
  cluster_name  = aws_eks_cluster.kkamji_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_caller_identity.current.arn

  access_scope {
    type = "cluster"
  }
}

# EKS 액세스 엔트리 생성
resource "aws_eks_access_entry" "cluster_admin_access" {
  cluster_name  = aws_eks_cluster.kkamji_cluster.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

######################################################################
## IAM for EKS Cluster Access Entry (Role 기준)
######################################################################

# data "aws_iam_policy_document" "admin_assume_role_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "AWS"
#       identifiers = [data.aws_caller_identity.current.arn]
#     }
#   }
# }

# # 클러스터 관리용 IAM 역할 생성
# resource "aws_iam_role" "kkamji_cluster_admin" {
#   name               = "kkamji_cluster_admin"
#   assume_role_policy = data.aws_iam_policy_document.admin_assume_role_policy.json
# }


# resource "aws_eks_access_policy_association" "kkamji_cluster_admin" {
#   cluster_name  = aws_eks_cluster.kkamji_cluster.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = aws_iam_role.kkamji_cluster_admin.arn

#   access_scope {
#     type       = "cluster"
#   }
# }

# # EKS 액세스 엔트리 생성
# resource "aws_eks_access_entry" "cluster_admin_access" {
#   cluster_name  = aws_eks_cluster.kkamji_cluster.name
#   principal_arn = aws_iam_role.kkamji_cluster_admin.arn
#   type          = "STANDARD"
# }