terraform {
  required_version = "= 0.12.31"
}

provider "aws" {
  region  = var.region
  version = "~> 5.0"
}