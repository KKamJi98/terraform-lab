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

  node_group_name    = "system"
  node_ami_id        = "ami-02dae848385169479"
  node_instance_type = "t4g.small"

  node_desired_size = 3
  node_min_size     = 1
  node_max_size     = 3

  node_max_pods = 110
  node_labels = {
    node_group                = "system"
    "karpenter.sh/controller" = "true"
  }

  enable_prefix_delegation = true

  tags = local.tags
}
