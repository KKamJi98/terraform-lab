provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # backend "s3" {
  #   bucket = "kkamji-terraform-state"
  #   key    = "dev/terraform.tfstate"
  #   region = "ap-northeast-1"

  #   dynamodb_table = "kkamji-terraform-state-locks"
  #   encrypt        = true
  # }
}
