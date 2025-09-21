variable "region" {
  description = "Specifies the AWS region where Terraform will operate."
  type        = string
  default     = "ap-northeast-2"
}

variable "domain_name" {
  description = "Primary domain name for the ACM certificate."
  type        = string
  default     = "*.kkamji.net"
}

variable "subject_alternative_names" {
  description = "Additional Subject Alternative Names to include in the certificate."
  type        = list(string)
  default     = ["kkamji.net"]
}

variable "validation_method" {
  description = "Validation method for the ACM certificate. DNS is recommended."
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "validation_method must be either DNS or EMAIL."
  }
}

variable "create_route53_records" {
  description = "Whether Terraform should manage Route 53 records for DNS validation."
  type        = bool
  default     = true

  validation {
    condition     = var.create_route53_records == false || var.validation_method == "DNS"
    error_message = "DNS records require validation_method to be DNS."
  }

  validation {
    condition     = var.create_route53_records == false || var.hosted_zone_id != null || var.hosted_zone_name != null
    error_message = "When create_route53_records is true either hosted_zone_id or hosted_zone_name must be provided."
  }
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID where DNS validation records will be created."
  type        = string
  default     = null
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name used when the hosted zone ID is unknown."
  type        = string
  default     = "kkamji.net"
}

variable "hosted_zone_private_zone" {
  description = "Indicates whether the hosted zone is a private hosted zone."
  type        = bool
  default     = false
}

variable "validation_record_ttl" {
  description = "TTL in seconds to apply to DNS validation records."
  type        = number
  default     = 60

  validation {
    condition     = var.validation_record_ttl > 0
    error_message = "validation_record_ttl must be greater than 0."
  }
}

variable "perform_certificate_validation" {
  description = "Whether to run aws_acm_certificate_validation after creating DNS records."
  type        = bool
  default     = true
}

variable "transparency_logging_enabled" {
  description = "Controls whether certificate transparency logging is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the ACM certificate."
  type        = map(string)
  default     = {}
}
