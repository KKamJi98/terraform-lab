#######################################################################
# EKS Cluster
#######################################################################

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.34"
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "service_ipv4_cidr" {
  description = "Kubernetes service IPv4 CIDR"
  type        = string
  default     = "172.20.0.0/16"
}

variable "endpoint_private_access" {
  description = "Enable private access to the EKS API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to the EKS API endpoint"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks that can access the public EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Grant cluster creator admin permissions"
  type        = bool
  default     = true
}

variable "enable_cluster_admin_access_entry" {
  description = "Create EKS access entries for the current caller"
  type        = bool
  default     = true
}

#######################################################################
# Managed Node Group
#######################################################################

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "default"
}

variable "node_role_name" {
  description = "IAM role name for managed node group"
  type        = string
  default     = null
}

variable "node_instance_type" {
  description = "Instance type for managed node group"
  type        = string
  default     = "t4g.small"
}

variable "node_ami_id" {
  description = "Custom AMI ID for managed node group"
  type        = string
  default     = "ami-02dae848385169479"
}

variable "node_desired_size" {
  description = "Desired size for managed node group"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum size for managed node group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum size for managed node group"
  type        = number
  default     = 3
}

variable "node_max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 110
}

variable "node_labels" {
  description = "Labels for managed node group"
  type        = map(string)
  default = {
    node_group = "system"
  }
}

variable "ssh_key_name" {
  description = "SSH key name for nodes"
  type        = string
  default     = null
}

#######################################################################
# Addons / Network
#######################################################################

variable "enable_prefix_delegation" {
  description = "Enable VPC CNI prefix delegation"
  type        = bool
  default     = true
}

#######################################################################
# Tags
#######################################################################

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
