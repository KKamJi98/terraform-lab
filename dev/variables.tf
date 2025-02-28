variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "region" {
  description = "The AWS region to launch the server in"
  type        = string
  default     = "ap-northeast-2"
}

variable "public_key_string" {
  description = "The public key to use for SSH access"
  type        = string
  sensitive   = true
}

variable "user_names" {
  description = "IAM user name"
  type        = list(string)
  default     = ["secrets_manager", "external_dns"]
}
