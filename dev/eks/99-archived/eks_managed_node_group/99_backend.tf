######################################################################
## HCP Terraform Backend Configuration
######################################################################
terraform {
  cloud {
    organization = "kkamji-lab"

    workspaces {
      name = "eks_mng_cluster"
    }
  }
}
