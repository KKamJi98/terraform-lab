###############################################################
# VPC
###############################################################

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type = bool
  default = false
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type = bool
  default = false
}

variable "name" {
  description = "The name of the VPC"
  type = string
  default = null
}

variable "tags" {
  description = "Additional tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of availability zones to deploy subnets in"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d"]
}

###############################################################
# Public Subnets
###############################################################

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch"
  type = bool
  default = false
}

###############################################################
# Public Subnets
###############################################################

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}