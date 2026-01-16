module "eks" {
  source = "../../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = "1.34"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]

  service_ipv4_cidr = "172.20.0.0/16"

  enable_cluster_creator_admin_permissions = false

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
    arm64-custom-ami = {
      ami_type      = "CUSTOM"
      ami_id        = "ami-07dfd5a6419303aec"
      instance_type = "t4g.small"
      desired_size  = 1
      min_size      = 1
      max_size      = 1
      disk_size     = 30
      max_pods      = 110
      labels        = {}
    }
    # arm64-bottlerocket = {
    #   ami_type      = "BOTTLEROCKET_ARM_64"
    #   ami_id        = null
    #   instance_type = "t4g.small"
    #   desired_size  = 1
    #   min_size      = 1
    #   max_size      = 1
    #   disk_size     = 30
    #   max_pods      = 110
    #   labels        = {}
    # }
  }

  enable_prefix_delegation = true

  tags = local.tags
}
