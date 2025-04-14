provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}