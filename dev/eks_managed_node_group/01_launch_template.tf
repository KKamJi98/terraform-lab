locals {
  cluster_name     = aws_eks_cluster.kkamji_cluster.name
  cluster_endpoint = aws_eks_cluster.kkamji_cluster.endpoint
  cluster_ca       = aws_eks_cluster.kkamji_cluster.certificate_authority[0].data
  cluster_cidr     = aws_eks_cluster.kkamji_cluster.kubernetes_network_config[0].service_ipv4_cidr
}

###############################################################
# AL2023_ARM64_AMI_ID & User Data
###############################################################

data "aws_ssm_parameter" "eks_al2023_arm64_ami_id" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.kkamji_cluster.version}/amazon-linux-2023/arm64/standard/recommended/image_id"
}

data "template_cloudinit_config" "node_userdata" {
  part {
    # MIME‑part 헤더
    content_type = "application/node.eks.aws"

    # nodeadm YAML
    content = <<-EOF
      ---
      apiVersion: node.eks.aws/v1alpha1
      kind: NodeConfig
      spec:
        cluster:
          name: ${local.cluster_name}
          apiServerEndpoint: ${local.cluster_endpoint}
          certificateAuthority: ${local.cluster_ca}
          cidr: ${local.cluster_cidr}
        kubelet:
          config:
            maxPods: 110
            clusterDNS:
              - 172.20.0.10
          flags:
            - "--node-labels=node_group=operation"
    EOF
  }
}

###############################################################
# ARM64 Node Group Launch Template
###############################################################

resource "aws_launch_template" "kkamji_arm64_lt" {
  name_prefix   = "kkamji-arm64-ng-"
  image_id      = data.aws_ssm_parameter.eks_al2023_arm64_ami_id.value
  instance_type = "t4g.small"
  key_name      = data.terraform_remote_state.basic.outputs.key_pair_name

  user_data = base64encode(data.template_cloudinit_config.node_userdata.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "kkamji-arm64-ng" }
  }
}

