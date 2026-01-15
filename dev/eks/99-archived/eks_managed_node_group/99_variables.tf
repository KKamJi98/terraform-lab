######################################################################
## Base Terraform variables
######################################################################
variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "ap-northeast-2"
}

######################################################################
## EKS Cluster
######################################################################
variable "public_access_cidrs" {
  description = "CIDR blocks to allow public access to the EKS cluster"
  type        = list(string)
  default     = []
}