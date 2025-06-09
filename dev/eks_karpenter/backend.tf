terraform {
  cloud {
    organization = "KKamJi"

    workspaces {
      name = "eks_karpenter"
    }
  }
}
