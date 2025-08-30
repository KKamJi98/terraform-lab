terraform {
  cloud {
    organization = "kkamji-lab"

    workspaces {
      name = "eks_simple_example"
    }
  }
}