###############################################################
# VPC
###############################################################

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

###############################################################
# Public Subnets
###############################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.name}-public-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) -1, 1)}"
    },
    var.tags
  )
}

###############################################################
# Private Subnets
###############################################################

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.name}-private-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) -1, 1)}"
    },
    var.tags
  )
}