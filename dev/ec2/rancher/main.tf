##########################################################
## IAM Role for SSM Access
##########################################################
resource "aws_iam_role" "rancher_ssm" {
  name = "rancher-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "rancher-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "rancher_ssm" {
  role       = aws_iam_role.rancher_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "rancher" {
  name = "rancher-instance-profile"
  role = aws_iam_role.rancher_ssm.name
}

##########################################################
## Rancher Security Group
##########################################################
resource "aws_security_group" "rancher_sg" {
  name        = "rancher_sg"
  description = "Security group for Rancher server"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  iam_instance_profile   = aws_iam_instance_profile.rancher.name

  user_data = file("${path.module}/user_data/rancher_docker.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "rancher-server"
  }
}
