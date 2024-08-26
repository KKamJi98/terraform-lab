output "public_ip" {
  value       = aws_instance.app.public_ip
  description = "The public IP address of the web server"
}
# terraform output
# terraform output public_ip

output "alb_dns_name" {
  value = aws_lb.this.dns_name
  description = "The domain name of the load balancer"
}