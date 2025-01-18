data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "eks_mng_cluster"
    }
  }
}