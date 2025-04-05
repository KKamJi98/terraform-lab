
##########################################################
## EC2 Instance (Prometheus) - Disabled count = 0
##########################################################
resource "aws_instance" "prometheus_ec2" {
  count                  = 0
  ami                    = data.aws_ssm_parameter.ubuntu_24_04_ami.value
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