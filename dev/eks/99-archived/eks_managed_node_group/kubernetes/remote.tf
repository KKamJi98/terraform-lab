######################################################################
## Terraform Remote State Data Source
######################################################################
data "terraform_remote_state" "eks_cluster" {
  backend = "remote"
  config = {
    organization = "kkamji-lab"
    workspaces = {
      name = "eks_mng_cluster"
    }
  }
}
