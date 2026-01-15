######################################################################
## HCP Terraform Backend Configuration
######################################################################
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kkamji-lab"

    workspaces {
      name = "eks_mng_cluster-access_entry_test"
    }
  }

  required_version = "0.12.31"
}
