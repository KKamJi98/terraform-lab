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
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
  # backend = "remote"
  # config = {
  #   organization = "KKamJi"
  #   workspaces = {
  #     name = "eks"
  #   }
  # }
}