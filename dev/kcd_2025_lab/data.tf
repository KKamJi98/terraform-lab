data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "basic"
    }
  }
}
