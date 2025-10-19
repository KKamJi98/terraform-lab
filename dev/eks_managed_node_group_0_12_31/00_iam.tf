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
  name               = "kkamji-al2023-eks-managed-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

# AmazonEKSClusterPolicy 정책을 IAM 역할에 연결
resource "aws_iam_role_policy_attachment" "kkamji_cluster" {
  role       = aws_iam_role.kkamji_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

######################################################################
## IAM for EKS Node Group
######################################################################

resource "aws_iam_role" "kkamji_node_group" {
  name = "eks-managed-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.kkamji_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.kkamji_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.kkamji_node_group.name
}

