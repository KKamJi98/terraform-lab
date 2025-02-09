##########################################################
## EC2 Instance
##########################################################

# output "ec2_instance_id" {
#   value       = aws_instance.test_ec2.id
#   description = "The ID of the EC2 instance"
# }

# output "ec2_instance_public_ip" {
#   value       = aws_instance.test_ec2.public_ip
#   description = "The public IP address of the EC2 instance"
# }

##########################################################
## EC2 Instance (Prometheus)
##########################################################

output "prometheus_ec2_instance_id" {
 value       = aws_instance.prometheus_ec2.id
 description = "The ID of the EC2 instance"
}

output "prometheus_ec2_instance_public_ip" {
 value       = aws_instance.prometheus_ec2.public_ip
 description = "The public IP address of the EC2 instance"
}

##########################################################
## EC2 Instance (templatefile_example)
##########################################################

# output "templatefile_ec2_instance_public_ip" {
#   value = aws_instance.templatefile_example.public_ip
# }
