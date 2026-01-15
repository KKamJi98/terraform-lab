##########################################################
## Data
##########################################################
data "aws_ssm_parameter" "ubuntu_24_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_ssm_parameter" "ubuntu_24_04_ami_arm64" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}

data "aws_ssm_parameter" "ubuntu_22_04_ami_arm64" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}

locals {
  asg_name = "test_asg"
}

##########################################################
## Security Group
##########################################################
resource "aws_security_group" "test_asg_sg" {
  name        = "test_asg_sg"
  description = "Allow ALL traffic"
  vpc_id      = data.terraform_remote_state.basic.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##########################################################
## Launch Template
##########################################################
resource "aws_launch_template" "test_lt" {
  name                   = "test_lt"
  image_id               = data.aws_ssm_parameter.ubuntu_24_04_ami.value
  key_name               = data.terraform_remote_state.basic.outputs.key_pair_name
  vpc_security_group_ids = [aws_security_group.test_asg_sg.id]
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/template/example.tftpl")
}

##########################################################
## Auto Scaling Group
##########################################################
resource "aws_autoscaling_group" "test_asg" {
  name                      = local.asg_name
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 3
  health_check_grace_period = 120
  health_check_type         = "ELB"
  vpc_zone_identifier       = slice(data.terraform_remote_state.basic.outputs.public_subnet_ids, 0, 2)
  termination_policies      = ["OldestInstance"]
  target_group_arns         = [aws_lb_target_group.test_tg.arn] # Target Group 연결

  launch_template {
    id      = aws_launch_template.test_lt.id
    version = "$Latest"
  }


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 80  # 기존 인스턴스의 일부만 헬시해도 업데이트 진행
      instance_warmup        = 180 # 인스턴스 헬스체크 준비 시간을 180초로 단축
    }
    # triggers = ["desired_capacity"] # desired_capacity 혹은 launch_template에 변경사항이 발생했을 때 롤링 업데이트
    triggers = ["desired_capacity", "launch_template"] # desired_capacity 혹은 launch_template에 변경사항이 발생했을 때 롤링 업데이트
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = local.asg_name
    propagate_at_launch = true
  }
}

##########################################################
## Elastic Load Balancer
##########################################################

resource "aws_lb" "test_alb" {
  name               = "test-alb"
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.basic.outputs.public_subnet_ids
  security_groups    = [aws_security_group.test_asg_sg.id]
}

resource "aws_lb_target_group" "test_tg" {
  name                 = "test-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.basic.outputs.vpc_id
  deregistration_delay = 120

  health_check {
    protocol = "HTTP"
    path     = "/"
    # 필요에 따라 interval, matcher, etc. 세부 설정 가능
  }
}

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}
