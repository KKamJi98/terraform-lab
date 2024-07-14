variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "AMIs" {
  type = map(string)
  default = {
    us-east-1 = "ami-04a81a99f5ec58529"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}