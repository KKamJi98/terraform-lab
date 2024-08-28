###############################################################
# Instance
###############################################################

variable "ami" {
  description = "The AMI to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
}

variable "subnet_id" {
  description = "The subnet to start the instance in."
  type        = string
  default     = null
}

variable "host_id" {
  description = "The host ID to use for the instance."
  type        = string
  default     = null
}

variable "key_name" {
  description = "The name of the key pair to use for the instance."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "The name of the IAM instance profile to attach to the EC2 instance"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "The name to use for the instance."
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the instance."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the VPC"
  type        = map(string)
  default     = {}
}