output "key_pair_name" {
  value       = aws_key_pair.my_key.key_name
  description = "The name of the key pair used to launch the server"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The IDs of the private subnets"
}

output "all_arns" {
  description = "ARNs of all users"
  # value = aws_iam_user.this[*].arn
  value = aws_iam_user.this
}

output "app_security_group_id" {
  value       = module.app_security_group.aws_security_group_id
  description = "The ID of the application security group"
}

# terraform output
# terraform output public_ip

# output "alb_dns_name" {
#   value = aws_lb.this.dns_name
#   description = "The domain name of the load balancer"
# }

# output "public_ip" {
#   value       = module.app.public_ip
#   description = "The public IP address of the web server"
# }
