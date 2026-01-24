#######################################################################
# Control Plane Logging
#######################################################################

resource "aws_cloudwatch_log_group" "cluster" {
  count = var.create_cluster_log_group && length(var.cluster_enabled_log_types) > 0 ? 1 : 0

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
  kms_key_id        = var.cluster_log_kms_key_id

  tags = var.tags
}
