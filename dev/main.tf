module "vpc" {
  source               = "../modules/vpc"

  name                 = "kkamji-dev-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  availability_zones = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d"]
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch = true
  private_subnet_cidr_blocks = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ec2" {
  source = "../modules/ec2"
  ami           = "ami-05d2438ca66594916"
  instance_type = "t2.micro"
  # element를 사용하면 에러 처리에 더 용이함
  subnet_id = module.vpc.public_subnet_ids[0]
  key_name = "kkam_key_pair"

  user_data = templatefile("${path.root}/template/user_data.sh", {
    server_port = "8080"
  })
  
  instance_name = "kkamji_instance"
}



# resource "aws_instance" "app" {
#   instance_type          = "t2.micro"
#   ami                    = "ami-05d2438ca66594916"
#   vpc_security_group_ids = [aws_security_group.web_instance.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World" > index.html
#               nohup busybox httpd -f -p ${var.server_port} &
#               EOF

#   tags = {
#     Name = "kkamji_instance"
#   }
# }

# resource "aws_security_group" "web_instance" {
#   name = "kkamji_SG"

#   ingress {
#     from_port   = var.server_port
#     to_port     = var.server_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_launch_configuration" "this" {
#   image_id               = "ami-05d2438ca66594916"
#   instance_type          = "t2.micro"

#   security_groups = [aws_security_group.web_instance.id]
#   user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello from $(hostname)" > index.html
#                 nohup busybox httpd -f -p ${var.server_port} &
#                 EOF

#   lifecycle {
#     # 새로운 리소스를 생성한 뒤 기존 리소스를 삭제
#     create_before_destroy = true
#   }
# }

# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# resource "aws_autoscaling_group" "this" {
#   launch_configuration = aws_launch_configuration.this.name
#   vpc_zone_identifier = data.aws_subnets.default.ids

#   target_group_arns = [aws_lb_target_group.asg.arn]
#   # default = "EC2" -> VM이 완전히 다운되거나 도달할 수 없는 경우 비정상
#   # "ELB" - ASG가 대상 그룹의 상태를 확인하여 인스턴스가 정상인지 여부를 판별. 만약 상태 불량으로 보고되면 인스턴스를 자동르로 교체
#   health_check_type = "ELB"

#   min_size = 2
#   max_size = 10

#   tag {
#     key = "Name"
#     value = "kkamji-asg"
#     propagate_at_launch = true
#   } 
# }

# resource "aws_lb" "this" {
#   name = "kkamji-alb"
#   load_balancer_type = "application"
#   subnets = data.aws_subnets.default.ids
#   security_groups = [aws_security_group.alb.id]
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.this.arn
#   port = 80
#   protocol = "HTTP"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "404: page not found"
#       status_code = 404
#     }
#   }
# }

# resource "aws_security_group" "alb" {
#   name = "kkamji-alb-SG"

#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_lb_target_group" "asg" {
#   name = "kkamji-alb-tg"
#   port = var.server_port
#   protocol = "HTTP"
#   vpc_id = data.aws_vpc.default.id

#   health_check {
#     path = "/"
#     protocol = "HTTP"
#     matcher = "200"
#     interval = 15
#     timeout = 3
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_listener_rule" "asg" {
#   listener_arn = aws_lb_listener.http.arn
#   priority = 100

#   condition {
#     path_pattern {
#       values = ["*"]  
#     }
#   }

#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.asg.arn
#   }
# }
