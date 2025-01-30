output "ec2_instance_id" {
  value       = aws_instance.test_ec2.id
  description = "The ID of the EC2 instance"
}

output "ec2_instance_public_ip" {
  value       = aws_instance.test_ec2.public_ip
  description = "The public IP address of the EC2 instance"
}