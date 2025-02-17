terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "import_ec2"
    }
  }
}
