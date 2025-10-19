variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    type              = string
    user_name         = string
    tags              = map(string)
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        namespaces = list(string)
        type       = string
      })
    }))
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
