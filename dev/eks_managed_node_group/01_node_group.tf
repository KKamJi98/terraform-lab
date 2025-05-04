######################################################################
## EKS Node Group AMD64 AMI - AL2023
######################################################################
data "aws_ssm_parameter" "eks_al2023_amd64_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.kkamji_cluster.version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}

######################################################################
## EKS Node Group ARM64 AMI - AL2023
######################################################################
data "aws_ssm_parameter" "eks_al2023_arm64_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.kkamji_cluster.version}/amazon-linux-2023/arm64/standard/recommended/release_version"
}

######################################################################
## EKS Node Group - AWS Managed Launch Template
######################################################################
# resource "aws_eks_node_group" "eks_managed_node_group" {
#   cluster_name    = aws_eks_cluster.kkamji_cluster.name
#   # node_group_name = "operation"
#   node_group_name_prefix = "operation-"
#   # node_group_name_prefix = "operation" # 이름 뒤에 랜덤 문자열 붙음(중복 방지)
#   node_role_arn = aws_iam_role.kkamji_node_group.arn
#   subnet_ids    = data.terraform_remote_state.basic.outputs.public_subnet_ids

#   instance_types  = ["t4g.small"] # ARM_64_Instance
#   ami_type        = "AL2023_ARM_64_STANDARD"
#   release_version = nonsensitive(data.aws_ssm_parameter.eks_al2023_arm64_ami_release_version.value)

#   # instance_types  = ["t3.small"]             # x86 인스턴스
#   # ami_type        = "AL2023_X86_64_STANDARD" # 또는 생략(기본값)
#   # release_version = nonsensitive(data.aws_ssm_parameter.eks_al2023_amd64_ami_release_version.value)


#   labels = {
#     "node_group" = "operation"
#   }

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable_percentage = 25
#   }

#   # LT를 따로 지정하면 사용 불가
#   remote_access {
#     ec2_ssh_key = data.terraform_remote_state.basic.outputs.key_pair_name
#     # source_security_group_ids = [module.app_security_group.aws_security_group_id] #	SSH 접속을 허용할 클라이언트 측 보안 그룹 ID 목록
#   }

#   lifecycle {
#     create_before_destroy = false # EKS Node Group를 삭제하기 전에 새 EKS Node Group을 생성
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

######################################################################
## EKS Node Group - Custom Launch Template
######################################################################
resource "aws_eks_node_group" "eks_managed_node_group_custom_lt" {
  cluster_name    = aws_eks_cluster.kkamji_cluster.name
  # node_group_name = "operation"
  node_group_name_prefix = "operation-custom"
  # node_group_name_prefix = "operation" # 이름 뒤에 랜덤 문자열 붙음(중복 방지)
  node_role_arn = aws_iam_role.kkamji_node_group.arn
  subnet_ids    = data.terraform_remote_state.basic.outputs.public_subnet_ids

  # instance_types  = ["t4g.small"] # ARM_64_Instance
  # ami_type        = "AL2023_ARM_64_STANDARD"
  # release_version = nonsensitive(data.aws_ssm_parameter.eks_al2023_arm64_ami_release_version.value)

  # instance_types  = ["t3.small"]             # x86 인스턴스
  # ami_type        = "AL2023_X86_64_STANDARD" # 또는 생략(기본값)
  # release_version = nonsensitive(data.aws_ssm_parameter.eks_al2023_amd64_ami_release_version.value)


  labels = {
    "node_group" = "operation"
  }

  launch_template {
    id      = aws_launch_template.kkamji_arm64_lt.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable_percentage = 25
  }

  ## LT를 따로 지정하면 사용 불가
  # remote_access {
  #   ec2_ssh_key = data.terraform_remote_state.basic.outputs.key_pair_name
  #   # source_security_group_ids = [module.app_security_group.aws_security_group_id] #	SSH 접속을 허용할 클라이언트 측 보안 그룹 ID 목록
  # }

  lifecycle {
    create_before_destroy = true # EKS Node Group를 삭제하기 전에 새 EKS Node Group을 생성
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

