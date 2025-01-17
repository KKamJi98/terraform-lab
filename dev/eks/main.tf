# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "kkamji-cluster"
#   cluster_version = "1.31"

#   bootstrap_self_managed_addons = false
#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   # Optional
#   cluster_endpoint_public_access = true

#   # Optional: Adds the current caller identity as an administrator via cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   vpc_id                   = "vpc-1234556abcdef"
#   subnet_ids               = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
#   control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#   }

#   eks_managed_node_groups = {
#     example = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = ["m5.xlarge"]

#       min_size     = 2
#       max_size     = 10
#       desired_size = 2
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }