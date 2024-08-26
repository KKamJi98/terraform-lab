provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }
  }
}

resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-2a"
  ami               = "ami-008d41dbe16db6778"

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              git clone https://github.com/brikis98/php-app.git /var/www/html/app
              service httpd start
              EOF
}