provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}

terraform {
  required_version = ">= 1.11.0"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

