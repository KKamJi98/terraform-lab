######################################################################
## HCP Terraform Backend Configuration
######################################################################
terraform {
  cloud {
    organization = "kkamji-lab"

    workspaces {
      name = "kubernetes"
    }
  }
}

