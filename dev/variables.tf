variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "region" {
  description = "The AWS region to launch the server in"
  type        = string
  default     = "ap-southeast-1"
}