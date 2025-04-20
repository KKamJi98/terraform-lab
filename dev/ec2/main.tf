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
## EC2 Instance - InfluxDB (Ubuntu24.04, CentOS7)
##########################################################

resource "aws_instance" "influxdb_ubuntu_24_04" {
  count                  = 2
  ami                    = data.aws_ssm_parameter.ubuntu_24_04_ami.value
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  # Ubuntu용 InfluxDB 설치 스크립트
  user_data = file("${path.module}/user_data/influxdb_install_ubuntu.sh")

  tags = {
    Name = "influxdb-${count.index + 1}"
  }
}

# influxdb_ubuntu_24_04__instance_public_ip = [
#         "3.34.139.206",
#         "3.36.114.208",
#     ]