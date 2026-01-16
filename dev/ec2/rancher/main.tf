##########################################################
## Rancher Security Group
##########################################################
resource "aws_security_group" "rancher_sg" {
  name        = "rancher_sg"
  description = "Security group for Rancher server"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rancher-sg"
  }
}

##########################################################
## Rancher EC2 Instance (Amazon Linux 2023 ARM64)
##########################################################
resource "aws_instance" "rancher" {
  ami                    = data.aws_ssm_parameter.al2023_arm64_ami.value
  instance_type          = "t4g.small"
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.rancher_sg.id]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

  user_data = file("${path.module}/user_data/rancher_docker.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "rancher-server"
  }
}
