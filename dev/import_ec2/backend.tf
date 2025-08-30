terraform {
  cloud {
    organization = "kkamji-lab"

    workspaces {
      name = "import_ec2"
    }
  }
}
