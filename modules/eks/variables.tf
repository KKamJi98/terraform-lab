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
  default     = false
}

variable "enable_oidc_provider" {
  description = "Create IAM OIDC provider for IRSA"
  type        = bool
  default     = true
}

variable "node_role_name" {
  description = "IAM role name for managed node group"
  type        = string
  default     = null
}

#######################################################################
# Managed Node Groups
#######################################################################

variable "node_groups" {
  description = "Managed node groups configuration"
  type = map(object({
    ami_type      = string
    ami_id        = string
    instance_type = string
    desired_size  = number
    min_size      = number
    max_size      = number
    disk_size     = number
    max_pods      = number
    labels        = map(string)
  }))

  validation {
    condition = alltrue([
      for _, ng in var.node_groups :
      ng.ami_type != "CUSTOM" || coalesce(ng.ami_id, "") != ""
    ])
    error_message = "node_groups: ami_type이 \"CUSTOM\"인 경우 ami_id는 필수입니다."
  }
}

variable "ssh_key_name" {
  description = "SSH key name for nodes"
  type        = string
  default     = null
}

variable "node_group_update_max_unavailable_percentage" {
  description = "Max unavailable percentage during managed node group updates"
  type        = number
  default     = 100

  validation {
    condition     = var.node_group_update_max_unavailable_percentage >= 0 && var.node_group_update_max_unavailable_percentage <= 100
    error_message = "node_group_update_max_unavailable_percentage must be between 0 and 100."
  }
}

#######################################################################
# Access Entries
#######################################################################

variable "allow_empty_access_entries" {
  description = "Allow empty access_entries even when cluster creator admin permissions are disabled"
  type        = bool
  default     = false
}

variable "access_entries" {
  description = "EKS Access Entries to grant IAM principals cluster access"
  type = map(object({
    kubernetes_groups = optional(list(string))
    principal_arn     = string
    type              = optional(string, "STANDARD")
    user_name         = optional(string)
    tags              = optional(map(string), {})
    policy_associations = optional(map(object({
      policy_arn = string
      access_scope = object({
        namespaces = optional(list(string))
        type       = string
      })
    })), {})
  }))
  default  = {}
  nullable = false

  validation {
    condition     = var.enable_cluster_creator_admin_permissions || var.allow_empty_access_entries || length(var.access_entries) > 0
    error_message = "access_entries must not be empty when enable_cluster_creator_admin_permissions is false. Set allow_empty_access_entries=true to bypass."
  }
}

#######################################################################
# Addons / Network
#######################################################################

variable "addons" {
  description = "EKS addons configuration"
  type = map(object({
    addon_version               = optional(string)
    configuration_values        = optional(string)
    preserve                    = optional(bool)
    resolve_conflicts_on_create = optional(string)
    resolve_conflicts_on_update = optional(string)
    pod_identity_association = optional(list(object({
      role_arn        = string
      service_account = string
    })), [])
    tags = optional(map(string), {})
  }))
  default  = {}
  nullable = false
}

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
