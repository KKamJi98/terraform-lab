module "eks" {
  source = "../../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = "1.34"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  endpoint_private_access           = local.network.endpoint_private_access
  endpoint_public_access            = local.network.endpoint_public_access
  public_access_cidrs               = local.network.public_access_cidrs
  allow_public_access_from_anywhere = local.network.allow_public_access_from_anywhere

  service_ipv4_cidr = local.network.service_ipv4_cidr

  enable_cluster_creator_admin_permissions     = false
  enable_oidc_provider                         = false
  node_group_update_max_unavailable_percentage = 100

  access_entries = local.access_entries

  node_groups = local.node_groups

  enable_prefix_delegation = true

  addons = local.addons

  tags = local.tags
}
