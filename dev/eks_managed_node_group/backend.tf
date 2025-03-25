######################################################################
## HCP Terraform Backend Configuration
######################################################################
terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "eks_mng_cluster"
    }
  }
}
