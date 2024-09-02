###############################################################
# security group
###############################################################

variable "name" {
  description = "Name of the security group name"
  type        = string
  default     = "default"
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Default security group"
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}

###############################################################
# security group rules
###############################################################

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "egress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}