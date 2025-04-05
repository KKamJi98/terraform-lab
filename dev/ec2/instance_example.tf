##########################################################
## EC2 Instance - Example
##########################################################

resource "aws_instance" "basic_ec2" {
  count                  = 0
  ami                    = "ami-0b5511d5304edfc79" #Ubuntu 24.04 arm64
  instance_type          = "t4g.small"
  subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "basic_ec2"
  }

  depends_on = [aws_security_group.test_sg]
}

##########################################################
## EC2 Instance (templatefile_example)
##########################################################

resource "aws_instance" "templatefile_example" {
  count                  = 0
  ami                    = "ami-0b5511d5304edfc79"
  instance_type          = "t4g.small"
  subnet_id              = data.terraform_remote_state.basic.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name

  # 외부 스크립트 참조
  user_data = templatefile(
    "${path.module}/user_data/example.tpl",
    {
      name        = "Alice"
      environment = "staging"
    }
  )

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "templatefile_example"
  }
}
