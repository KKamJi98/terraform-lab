variable "region" {
  description = "The AWS region to launch the server in"
  type        = string
  default     = "ap-northeast-2"
}

variable "access_entries" {
  description = "Additional EKS access entries"
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
  default = {}
}
