locals {
  cluster_name = var.cluster_name

  tags = {
    creator = "kkamji"
    env     = var.environment
    cluster = local.cluster_name
  }
}
