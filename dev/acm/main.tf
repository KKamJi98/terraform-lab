locals {
  should_lookup_zone = var.create_route53_records && var.hosted_zone_id == null
}

data "aws_route53_zone" "this" {
  count        = local.should_lookup_zone ? 1 : 0
  name         = var.hosted_zone_name
  private_zone = var.hosted_zone_private_zone
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method

  options {
    certificate_transparency_logging_preference = var.transparency_logging_enabled ? "ENABLED" : "DISABLED"
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  validation_zone_id = var.create_route53_records ? (
    var.hosted_zone_id != null ? var.hosted_zone_id : try(data.aws_route53_zone.this[0].zone_id, null)
  ) : null

  domain_validation_records = {
    for option in aws_acm_certificate.this.domain_validation_options :
    option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }
}

resource "aws_route53_record" "validation" {
  for_each = var.create_route53_records ? local.domain_validation_records : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.validation_record_ttl
  type            = each.value.type
  zone_id         = local.validation_zone_id

  lifecycle {
    precondition {
      condition     = local.validation_zone_id != null
      error_message = "When create_route53_records is true you must set either hosted_zone_id or hosted_zone_name."
    }
  }
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.perform_certificate_validation && var.create_route53_records ? 1 : 0
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
