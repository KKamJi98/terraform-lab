output "rancher_public_ip" {
  value       = aws_instance.rancher.public_ip
  description = "Public IP of Rancher server"
}

output "rancher_public_dns" {
  value       = aws_instance.rancher.public_dns
  description = "Public DNS of Rancher server"
}
