resource "aws_instance" "example" {
  ami = "${lookup(var.AMIs, var.AWS_REGION)}"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}