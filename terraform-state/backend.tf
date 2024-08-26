terraform {
  backend "s3" {
    bucket = "terraform-state-exam-master"
    key    = "terraform/demo4"
    region = "us-east-1"
  }
}