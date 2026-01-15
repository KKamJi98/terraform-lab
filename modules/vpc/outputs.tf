###############################################################
# VPC
###############################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

###############################################################
# Public Subnets
###############################################################

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

###############################################################
# Private Subnets
###############################################################

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

###############################################################
# Route Tables
###############################################################

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

###############################################################
# NAT Gateway
###############################################################

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.this[0].public_ip : null
}

output "nat_eip_id" {
  description = "The allocation ID of the Elastic IP for NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.this[0].id : null
}

###############################################################
# Internet Gateway
###############################################################

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
