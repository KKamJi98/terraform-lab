#######################################################################
# Locals
#######################################################################

locals {
  cluster_cidr = var.service_ipv4_cidr
  cluster_dns  = cidrhost(local.cluster_cidr, 10)

  node_role_name = coalesce(var.node_role_name, "${var.cluster_name}-node-role")

  custom_ami_node_groups = {
    for name, ng in var.node_groups : name => ng
    if ng.ami_type == "CUSTOM"
  }

  bottlerocket_node_groups = {
    for name, ng in var.node_groups : name => ng
    if ng.ami_type == "BOTTLEROCKET_ARM_64" || ng.ami_type == "BOTTLEROCKET_X86_64"
  }

  node_group_user_data = {
    for name, ng in local.custom_ami_node_groups :
    name => base64encode(templatefile(
      "${path.module}/templates/nodeconfig.tpl",
      {
        cluster_name     = aws_eks_cluster.this.name
        cluster_endpoint = aws_eks_cluster.this.endpoint
        cluster_ca       = aws_eks_cluster.this.certificate_authority[0].data
        cluster_cidr     = local.cluster_cidr
        cluster_dns      = local.cluster_dns
        max_pods         = ng.max_pods
      }
    ))
  }

  bottlerocket_user_data = {
    for name, ng in local.bottlerocket_node_groups :
    name => base64encode(templatefile(
      "${path.module}/templates/bottlerocket.tpl",
      {
        cluster_name     = aws_eks_cluster.this.name
        cluster_endpoint = aws_eks_cluster.this.endpoint
        cluster_ca       = aws_eks_cluster.this.certificate_authority[0].data
        cluster_dns      = local.cluster_dns
        max_pods         = ng.max_pods
      }
    ))
  }

  access_policy_associations = merge(
    {},
    [
      for entry_key, entry in var.access_entries : {
        for assoc_key, assoc in try(entry.policy_associations, {}) :
        "${entry_key}:${assoc_key}" => {
          entry_key    = entry_key
          policy_arn   = assoc.policy_arn
          access_scope = assoc.access_scope
        }
      }
    ]...
  )
}
