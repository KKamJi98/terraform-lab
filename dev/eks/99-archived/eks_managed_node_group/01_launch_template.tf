###############################################################
# Local Variable
###############################################################
locals {
  cluster_name     = aws_eks_cluster.kkamji_cluster.name
  cluster_endpoint = aws_eks_cluster.kkamji_cluster.endpoint
  cluster_ca       = aws_eks_cluster.kkamji_cluster.certificate_authority[0].data
  cluster_cidr     = aws_eks_cluster.kkamji_cluster.kubernetes_network_config[0].service_ipv4_cidr
  cluster_dns      = cidrhost(local.cluster_cidr, 10)
  node_group       = "operation"

  # ── cloud‑init user‑data 전체 (멀티파트 그대로)
  user_data = base64encode(templatefile(
    "${path.module}/templates/nodeconfig.tpl",
    {
      cluster_name     = local.cluster_name
      cluster_endpoint = local.cluster_endpoint
      cluster_ca       = local.cluster_ca
      cluster_cidr     = local.cluster_cidr
      cluster_dns      = local.cluster_dns
      node_group       = local.node_group
    }
  ))
}

###############################################################
# AL2023_ARM64_AMI_ID & User Data
###############################################################

data "aws_ssm_parameter" "eks_al2023_arm64_ami_id" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.kkamji_cluster.version}/amazon-linux-2023/arm64/standard/recommended/image_id"
}

# data "cloudinit_config" "linux_eks_managed_node_group" {
#   base64_encode = true
#   gzip          = false
#   boundary      = "//"

#   # Prepend to existing user data supplied by AWS EKS
#   part {
#     content      = var.pre_bootstrap_user_data
#     content_type = "text/x-shellscript"
#   }
# }
###############################################################
# ARM64 Node Group Launch Template
###############################################################

resource "aws_launch_template" "kkamji_arm64_lt" {
  name_prefix   = "kkamji-arm64-ng-"
  image_id      = data.aws_ssm_parameter.eks_al2023_arm64_ami_id.value
  instance_type = "t4g.small"
  key_name      = data.terraform_remote_state.basic.outputs.key_pair_name

  user_data = local.user_data

  vpc_security_group_ids = [
    aws_security_group.remote_access.id,
    aws_eks_cluster.kkamji_cluster.vpc_config[0].cluster_security_group_id
  ]

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "eks-node-custom-lt-node" }
  }
}

