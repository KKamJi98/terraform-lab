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
  map_public_ip_on_launch = var.map_public_ip_on_launch
  
  tags = merge(
    {
      Name = "${var.name}-public-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) -1, 1)}"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
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

###############################################################
# Internet Gateway
###############################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}