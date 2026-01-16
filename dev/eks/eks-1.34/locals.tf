locals {
  cluster_name = "kkamji-eks-34"

  tags = {
    creator = "kkamji"
    env     = "dev"
    cluster = local.cluster_name
  }
}
