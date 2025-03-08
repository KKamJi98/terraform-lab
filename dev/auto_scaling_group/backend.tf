terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "asg"
    }
  }
}