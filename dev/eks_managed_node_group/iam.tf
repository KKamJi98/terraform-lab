######################################################################
## IAM for EKS Cluster
######################################################################

# EKS 클러스터용 IAM 역할의 AssumeRole 정책 정의
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

# EKS 클러스터용 IAM 역할 생성
resource "aws_iam_role" "kkamji_cluster" {
  name               = "kkamji_al2023_eks_role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

# AmazonEKSClusterPolicy 정책을 IAM 역할에 연결
resource "aws_iam_role_policy_attachment" "kkamji_cluster" {
  role       = aws_iam_role.kkamji_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

