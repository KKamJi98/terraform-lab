######################################################################
## HCP Terraform Backend Configuration
######################################################################
terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "kubernetes"
    }
  }
}

