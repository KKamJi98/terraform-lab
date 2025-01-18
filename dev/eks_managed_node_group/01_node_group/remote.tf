data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "basic"
    }
  }
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "eks"
    }
  }
}

# data "terraform_remote_state" "eks_local" {
#   backend = "local"

#   config = {
#     path = "../terraform.tfstate"
#   }
# }