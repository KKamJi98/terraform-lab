## Provisioning EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = "1.33"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_driver
  ]

  addons = {
    coredns    = {}
    kube-proxy = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    aws-ebs-csi-driver = {
      pod_identity_association = local.ebs_csi_pod_identity_associations
    }
    metrics-server      = {}
    snapshot-controller = {}
  }

  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = false

  access_entries = merge(var.access_entries, local.cluster_creator_access_entry)

  vpc_id                   = data.terraform_remote_state.basic.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.basic.outputs.public_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  eks_managed_node_groups = {
    application = {
      node_group_name = "application"
      ami_type        = "AL2023_ARM_64_STANDARD"
      instance_types  = ["t4g.small"]
      capacity_type   = "ON_DEMAND"

      min_size     = 2
      max_size     = 3
      desired_size = 2

      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

      metadata_options = {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
        instance_metadata_tags      = "disabled"
      }

      update_config = local.default_update_config
      cloudinit_pre_nodeadm = [
        {
          content_type = "application/node.eks.aws"
          content      = <<-EOT
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  maxPods: 110
          EOT
        }
      ]
      labels = {
        "node.kubernetes.io/app" = "operation2"
      }
    }

    operation = {
      ami_type       = "AL2023_ARM_64_STANDARD"
      instance_types = ["t4g.small"]
      capacity_type  = "ON_DEMAND"

      min_size     = 2
      max_size     = 3
      desired_size = 2

      key_name = data.terraform_remote_state.basic.outputs.key_pair_name

      metadata_options = {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
        instance_metadata_tags      = "disabled"
      }

      update_config = local.default_update_config
      cloudinit_pre_nodeadm = [
        {
          content_type = "application/node.eks.aws"
          content      = <<-EOT
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  maxPods: 110
          EOT
        }
      ]
      labels = {
        "node.kubernetes.io/app" = "operation"
      }
    }
  }

  node_security_group_additional_rules = {
    metrics_server_10251 = {
      description                   = "Allow metrics-server on TCP 10251 from cluster"
      protocol                      = "tcp"
      from_port                     = 10251
      to_port                       = 10251
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  encryption_config = {}
}
