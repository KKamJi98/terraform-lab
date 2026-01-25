locals {
  cluster_name = var.cluster_name

  network = {
    endpoint_private_access           = true
    endpoint_public_access            = true
    public_access_cidrs               = ["0.0.0.0/0"]
    allow_public_access_from_anywhere = true
    service_ipv4_cidr                 = "172.20.0.0/16"
  }

  access_entries = {
    cluster-admin = {
      principal_arn = data.aws_caller_identity.current.arn
      policy_associations = {
        cluster-admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  node_groups = {
    arm64-bottlerocket = {
      ami_type      = "BOTTLEROCKET_ARM_64"
      ami_id        = null
      instance_type = "t4g.small"
      desired_size  = 2
      min_size      = 1
      max_size      = 3
      disk_size     = 30
      max_pods      = 110
      labels        = {}
      subnet_ids    = data.terraform_remote_state.vpc.outputs.public_subnet_ids
    }
  }

  addons = {
    "vpc-cni"                = {}
    "kube-proxy"             = {}
    "coredns"                = {}
    "eks-pod-identity-agent" = {}
    "aws-ebs-csi-driver" = {
      pod_identity_association = [
        {
          role_arn        = aws_iam_role.ebs_csi_driver.arn
          service_account = "ebs-csi-controller-sa"
        }
      ]
      after_core = true
    }
  }

  tags = {
    creator = "kkamji"
    env     = var.environment
    cluster = local.cluster_name
  }
}
