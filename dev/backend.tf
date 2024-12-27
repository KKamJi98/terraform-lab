terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.2"
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