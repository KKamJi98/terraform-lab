variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "kkamji-eks-34"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_state_organization" {
  description = "Terraform Cloud organization for VPC remote state"
  type        = string
  default     = "kkamji-lab"
}

variable "vpc_state_workspace" {
  description = "Terraform Cloud workspace name for VPC remote state"
  type        = string
  default     = "dev-vpc"
}
