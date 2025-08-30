terraform {
  cloud {
    organization = "kkamji-lab"

    workspaces {
      name = "acm"
    }
  }
}
