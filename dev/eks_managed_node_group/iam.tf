######################################################################
## IAM for EKS Cluster
######################################################################
# resource "aws_iam_role" "kkamji_cluster" {
#   name = "kkamji_al2023_eks_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "kkamji_cluster" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.kkamji_cluster.name
# }

data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kkamji_cluster" {
  name               = "kkamji_al2023_eks_role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "kkamji_cluster" {
  role       = aws_iam_role.kkamji_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

######################################################################
## IAM for EKS Cluster Access Entry
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

# resource "aws_iam_role" "kkamji_cluster_admin" {
#   name               = "kkamji_cluster_admin"
#   assume_role_policy = data.aws_iam_policy_document.admin_assume_role_policy.json
# }

# data "aws_iam_policy_document" "eks_admin_policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["eks:*"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "eks_admin_policy" {
#   name   = "eks_admin_policy"
#   policy = data.aws_iam_policy_document.eks_admin_policy.json
# }

# resource "aws_iam_role_policy_attachment" "attach_eks_admin_policy" {
#   role       = aws_iam_role.kkamji_cluster_admin.name
#   policy_arn = aws_iam_policy.eks_admin_policy.arn
# }

## AWS Provider가 사용하는 자격증명에 해당하는 유저를 Access Entry에 추가 AmazonEKSAdminPolicy 적용
# resource "aws_eks_access_entry" "cluster_admin_access" {
#   cluster_name      = aws_eks_cluster.kkamji_cluster.name
#   principal_arn     = aws_iam_role.kkamji_cluster_admin.arn
#   # principal_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
#   # access_entry_arn = data.aws_caller_identity.current.arn
#   # kubernetes_groups = ["system:masters"]
#   type              = "STANDARD"
# }

# import {
#   to = aws_eks_access_entry.my_eks_entry
#   id = "my_cluster_name:my_principal_arn"
# }