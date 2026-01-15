data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "kkamji-lab"
    workspaces = {
      name = "basic"
    }
  }
}

