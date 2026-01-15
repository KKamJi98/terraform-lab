variable "region" {
  description = "AWS region where the EKS cluster and related resources are created"
  type        = string
  default     = "ap-northeast-2"
  nullable    = false

  validation {
    condition     = length(var.region) > 0
    error_message = "region must be a non-empty AWS region identifier (e.g., ap-northeast-2)."
  }
}

variable "access_entries" {
  description = "EKS Access Entries to grant IAM principals cluster access (maps to EKS access entries)"
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
}
