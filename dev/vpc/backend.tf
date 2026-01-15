terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kkamji-lab"

    workspaces {
      name = "dev-vpc"
    }
  }
}
