##########################################################
## Security Group
##########################################################

resource "aws_security_group" "test_sg" {
  name        = "test_sg"
  description = "Allow ALL traffic"
  vpc_id      = data.terraform_remote_state.basic.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.my_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

##########################################################
## EC2 Instance
##########################################################

# resource "aws_instance" "basic_ec2" {
#   ami                    = "ami-0b5511d5304edfc79" #Ubuntu 24.04 arm64
#   instance_type          = "t4g.small"
#   subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
#   vpc_security_group_ids = [aws_security_group.test_sg.id]
#   key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#     Name        = "basic_ec2"
#   }

#   depends_on = [aws_security_group.test_sg]
# }

##########################################################
## EC2 Instance (Prometheus)
##########################################################

resource "aws_instance" "prometheus_ec2" {
  ami                    = "ami-0b5511d5304edfc79"
  instance_type          = "t4g.small"
  subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

  # 외부 스크립트 참조
  user_data = file("${path.module}/user_data/prometheus_install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "prometheus_ec2"
  }
}

##########################################################
## EC2 Instance (templatefile_example)
##########################################################

# resource "aws_instance" "templatefile_example" {
#   ami                    = "ami-0b5511d5304edfc79"
#   instance_type          = "t4g.small"
#   subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
#   vpc_security_group_ids = [aws_security_group.test_sg.id]
#   key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

#   # 외부 스크립트 참조
#   user_data = templatefile(
#     "${path.module}/user_data/example.tpl",
#     {
#       name        = "Alice"
#       environment = "staging"
#     }
#   )

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#     Name        = "templatefile_example"
#   }
# }
