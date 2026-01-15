provider "aws" {
  region  = var.region
  version = "= 5.100.0"
  profile = "kkamji"

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}
