locals {
  default_update_config = {
    max_unavailable_percentage = 50
  }

}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name                 = "kkamji-eks-mng"
  cluster_name         = data.terraform_remote_state.cluster.outputs.cluster_name
  cluster_version      = data.terraform_remote_state.cluster.outputs.cluster_version
  cluster_service_cidr = data.terraform_remote_state.cluster.outputs.cluster_service_cidr

  subnet_ids = data.terraform_remote_state.basic.outputs.public_subnet_ids

  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  # cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  # vpc_security_group_ids            = [module.eks.node_security_group_id]
  cluster_primary_security_group_id = data.terraform_remote_state.cluster.outputs.cluster_primary_security_group_id
  vpc_security_group_ids            = [data.terraform_remote_state.cluster.outputs.node_security_group_id]

  // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
  // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
  // use_custom_launch_template = false
  // disk_size = 50
  //
  //  # Remote access cannot be specified with a launch template
  # remote_access = {
  #   ec2_ssh_key               = data.terraform_remote_state.basic.outputs.key_name
  #   # source_security_group_ids = [aws_security_group.remote_access.id]
  #   source_security_group_ids = [aws_security_group.remote_access.id]
  # }

  min_size     = 1
  max_size     = 3
  desired_size = 1

  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  # taints = {
  #   dedicated = {
  #     key    = "dedicated"
  #     value  = "gpuGroup"
  #     effect = "NO_SCHEDULE"
  #   }
  # }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}