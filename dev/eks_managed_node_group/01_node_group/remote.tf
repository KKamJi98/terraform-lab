data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "basic"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "eks_mng_cluster"
    }
  }
}

# data "terraform_remote_state" "eks_local" {
#   backend = "local"

#   config = {
#     path = "../terraform.tfstate"
#   }
# }