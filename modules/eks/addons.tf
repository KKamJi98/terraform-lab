#######################################################################
# EKS Addons
#######################################################################

locals {
  addon_defaults = {
    "vpc-cni" = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = var.enable_prefix_delegation ? "true" : "false"
        }
      })
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
  }

  addons = merge(
    local.addon_defaults,
    {
      for name, addon in var.addons :
      name => merge(lookup(local.addon_defaults, name, {}), addon)
    }
  )
}

resource "aws_eks_addon" "this" {
  for_each = local.addons

  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.key

  addon_version               = try(each.value.addon_version, null)
  configuration_values        = try(each.value.configuration_values, null)
  preserve                    = try(each.value.preserve, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, null)
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, null)
  tags                        = merge(var.tags, try(each.value.tags, {}))

  dynamic "pod_identity_association" {
    for_each = try(each.value.pod_identity_association, [])
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }
}
