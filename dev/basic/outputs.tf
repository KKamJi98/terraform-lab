output "key_pair_name" {
  value       = aws_key_pair.my_key.key_name
  description = "The name of the key pair used to launch the server"
}

output "external_secrets_user_arn" {
  description = "The ARN of the external secrets user"
  # value = aws_iam_user.this[*].arn
  value = aws_iam_user.external_secrets.arn
}

output "external_dns_user_arn" {
  description = "The ARN of the external DNS user"
  value       = aws_iam_user.external_dns.arn
}

output "kkamji_security_group_id" {
  value       = module.kkamji_security_group.aws_security_group_id
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
