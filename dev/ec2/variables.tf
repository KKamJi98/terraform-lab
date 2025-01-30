variable "region" {
  description = "The AWS region to launch the server in"
  type        = string
  default     = "ap-northeast-2"
}

variable "my_ip" {
  description = "The IP address to allow SSH access from"
  type        = list(string)
}