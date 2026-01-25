#######################################################################
# Managed Node Group
#######################################################################

resource "aws_eks_node_group" "managed" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = coalesce(each.value.subnet_ids, var.subnet_ids)

  ami_type      = each.value.ami_type
  capacity_type = try(each.value.capacity_type, null)
  instance_types = each.value.ami_type == "CUSTOM" ? null : (
    length(coalesce(each.value.instance_types, [])) > 0 ? each.value.instance_types : [each.value.instance_type]
  )

  labels    = each.value.labels
  disk_size = each.value.ami_type == "CUSTOM" ? null : each.value.disk_size

  dynamic "launch_template" {
    for_each = each.value.ami_type == "CUSTOM" ? [1] : []
    content {
      id      = aws_launch_template.node_group[each.key].id
      version = "$Latest"
    }
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable_percentage = var.node_group_update_max_unavailable_percentage
  }

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      Name = "${var.cluster_name}-${each.key}"
    }
  )

  dynamic "taint" {
    for_each = try(each.value.taints, [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  dynamic "timeouts" {
    for_each = length(var.node_group_timeouts) == 0 ? [] : [var.node_group_timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  depends_on = [
    aws_eks_addon.this["vpc-cni"],
    aws_iam_role_policy_attachment.node_group_worker,
    aws_iam_role_policy_attachment.node_group_cni,
    aws_iam_role_policy_attachment.node_group_ecr,
  ]
}
