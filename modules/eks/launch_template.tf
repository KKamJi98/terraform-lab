#######################################################################
# Launch Template (Custom AMI + IMDSv2)
#######################################################################

resource "aws_launch_template" "node_group" {
  for_each = merge(
    local.custom_ami_node_groups,
    local.bottlerocket_node_groups
  )

  name_prefix   = "${var.cluster_name}-${each.key}-ng-"
  image_id      = each.value.ami_type == "CUSTOM" ? each.value.ami_id : null
  instance_type = each.value.instance_type
  key_name      = var.ssh_key_name

  user_data = each.value.ami_type == "CUSTOM" ? local.node_group_user_data[each.key] : local.bottlerocket_user_data[each.key]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = each.value.disk_size
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  vpc_security_group_ids = [
    aws_security_group.node.id,
    aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
  ]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-${each.key}"
      }
    )
  }
}
