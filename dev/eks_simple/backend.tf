terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "dev_eks_simple"
    }
  }
}