data "aws_ssm_parameter" "ubuntu_24_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

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

resource "aws_launch_template" "test_lc" {
  name = "test_lc"
  image_id = data.aws_ami.ubuntu_24_04_ami.value
  key_name = "test_key"
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  user_data = file("${path.module}/template/example.tftpl")

}

resource "aws_autocaling_group" "test_asg" {
  name = "test_asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 300 # EC2 인스턴스가 시작된 후 상태 확인을 시작하기 전에 대기하는 시간
  launch_configuration = aws_launch_configuration.test_lc.name
  vpc_zone_identifier = [aws_subnet.test_subnet_1.id, aws_subnet.test_subnet_2.id]

}