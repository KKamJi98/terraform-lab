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

  ingress {
    description = "Allow traffic from the same SG"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
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
## Docker Instances (AMD64, ARM64)
##########################################################
locals {
  instance_configs = {
    # amd64 = {
    #   ami           = data.aws_ssm_parameter.ubuntu_24_04_ami.value
    #   instance_type = "t2.micro"
    # }
    arm64 = {
      ami           = data.aws_ssm_parameter.ubuntu_24_04_ami_arm64.value
      instance_type = "t4g.small"
    }
  }
}

resource "aws_instance" "kkamji_host" {
  for_each = local.instance_configs

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

  # Docker,AWS CLI 설치 스크립트
  user_data = file("${path.module}/user_data/cloud_init_lxd_practice.sh")

  tags = {
    Name        = "docker-host-${each.key}"
    Environment = "dev"
  }
}




# influxdb_ubuntu_24_04__instance_public_ip = [
#         "3.34.139.206",
#         "3.36.114.208",
#     ]