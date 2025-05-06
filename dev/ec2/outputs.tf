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
## EC2 Instance (Docker Host)
##########################################################

output "docker_host_instance_id" {
  value       = [for inst in aws_instance.kkamji_host : inst.id]
  description = "The IDs of the EC2 instances"
}

output "docker_host_instance_public_ip" {
  value       = [for inst in aws_instance.kkamji_host : inst.public_ip]
  description = "The public IPs of the EC2 instances"
}

##########################################################
## EC2 Instance (InfluxDB)
##########################################################

# output "influxdb_ubuntu_24_04_instance_id" {
#   value       = aws_instance.influxdb_ubuntu_24_04[*].id
#   description = "The ID of the EC2 instance"
# }

# output "influxdb_ubuntu_24_04_instance_public_ip" {
#   value       = aws_instance.influxdb_ubuntu_24_04[*].public_ip
#   description = "The public IP address of the EC2 instance"
# }

##########################################################
## EC2 Instance (Prometheus)
##########################################################

# output "prometheus_ec2_instance_id" {
#   value       = aws_instance.prometheus_ec2.id
#   description = "The ID of the EC2 instance"
# }

# output "prometheus_ec2_instance_public_ip" {
#   value       = aws_instance.prometheus_ec2.public_ip
#   description = "The public IP address of the EC2 instance"
# }

##########################################################
## EC2 Instance (templatefile_example)
##########################################################

# output "templatefile_ec2_instance_public_ip" {
#   value = aws_instance.templatefile_example.public_ip
# }
