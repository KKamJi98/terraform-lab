variable "ami" {
  type        = string
  description = "The AMI to use for the instance."
}

variable "instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "subnet_id" {
  type        = string
  description = "The subnet to start the instance in."
  default     = null
}

variable "host_id" {
  type        = string
  description = "The host ID to use for the instance."
  default     = null
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for the instance."
  default     = null
}

variable "user_data" {
  type        = string
  description = "The user data to provide when launching the instance."
  default     = ""
}

variable "iam_instance_profile" {
  type        = string
  description = "The name of the IAM instance profile to attach to the EC2 instance"
  default     = null
}

variable "instance_name" {
  type        = string
  description = "The name to use for the instance."
  default     = ""
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to associate with the instance."
  default     = []
}