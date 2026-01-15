#######################################
# VPC
#######################################

module "vpc" {
  source = "../../modules/vpc"

  name                 = "kkamji-dev-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  availability_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  map_public_ip_on_launch   = true

  private_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway         = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    "karpenter.sh/discovery" = "kkamji-al2023"
  }
}
