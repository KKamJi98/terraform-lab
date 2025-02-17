terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "eks_simple_example"
    }
  }
}