provider "aws" {
  region = var.region

  default_tags {
    tags = {
      terraform   = "true"
      environment = "dev"
      creator     = "kkamji"
    }
  }
}

terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
