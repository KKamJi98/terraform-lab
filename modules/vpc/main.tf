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
      Name = "${var.name}-pub-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) - 1, 1)}"
    },
    var.tags,
    var.public_subnet_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-pub" },
    var.tags
  )
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
      Name = "${var.name}-pri-${substr(var.availability_zones[count.index], length(var.availability_zones[count.index]) - 1, 1)}"
    },
    var.tags,
    var.private_subnet_tags
  )
}

resource "aws_eip" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    { Name = "${var.name}-nat-eip" },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    { Name = "${var.name}-nat-gw" },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]

  lifecycle {
    precondition {
      condition     = length(var.public_subnet_cidr_blocks) > 0
      error_message = "At least one public subnet is required when enable_nat_gateway is true."
    }
  }
}

###############################################################
# Private Route Table
###############################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-pri" },
    var.tags
  )
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

###############################################################
# Internet Gateway
###############################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = var.name },
    var.tags
  )
}