data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = "kkamji-lab"
    workspaces = {
      name = "eks_mng_cluster-access_entry_test"
    }
  }
}

data "aws_caller_identity" "current" {}
