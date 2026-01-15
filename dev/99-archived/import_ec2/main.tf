resource "aws_instance" "kkamji-ec2" {
  ami           = "ami-024ea438ab0376a47"
  instance_type = "t2.micro"
  tags = {
    Name = "kkamji-ec2"
  }

  lifecycle {
    ignore_changes = [
      user_data,
      user_data_replace_on_change
    ]
  }
}