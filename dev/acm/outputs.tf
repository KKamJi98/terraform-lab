output "certificate_arn" {
  description = "ARN of the provisioned ACM certificate."
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_options" {
  description = "Domain validation options returned by ACM."
  value       = aws_acm_certificate.this.domain_validation_options
}

output "validation_record_fqdns" {
  description = "FQDNs of the DNS validation records created in Route 53."
  value       = var.create_route53_records ? [for record in aws_route53_record.validation : record.fqdn] : []
}
