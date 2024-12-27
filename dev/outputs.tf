output "public_ip" {
  value       = module.app.public_ip
  description = "The public IP address of the web server"
}

output "key_pair_name" {
  value       = aws_key_pair.my_key.key_name
  description = "The name of the key pair used to launch the server"
}

# terraform output
# terraform output public_ip

# output "alb_dns_name" {
#   value = aws_lb.this.dns_name
#   description = "The domain name of the load balancer"
# }

