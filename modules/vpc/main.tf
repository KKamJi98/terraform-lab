###############################################################
# VPC
###############################################################

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
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

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = "${var.name}-public-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) - 1, 1)}"
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
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

###############################################################
# Private Subnets
###############################################################

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.name}-private-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) - 1, 1)}"
    },
    var.tags
  )
}

resource "aws_eip" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"
}

resource "aws_nat_gateway" "private" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.this[count.index].id
  subnet_id = aws_subnet.public[1].id

  tags = {
    Name = "${var.name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.this]
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