<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_route53_records"></a> [create\_route53\_records](#input\_create\_route53\_records) | Whether Terraform should manage Route 53 records for DNS validation. | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary domain name for the ACM certificate. | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route 53 hosted zone ID where DNS validation records will be created. | `string` | `null` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Route 53 hosted zone name used when the hosted zone ID is unknown. | `string` | `null` | no |
| <a name="input_hosted_zone_private_zone"></a> [hosted\_zone\_private\_zone](#input\_hosted\_zone\_private\_zone) | Indicates whether the hosted zone is a private hosted zone. | `bool` | `false` | no |
| <a name="input_perform_certificate_validation"></a> [perform\_certificate\_validation](#input\_perform\_certificate\_validation) | Whether to run aws\_acm\_certificate\_validation after creating DNS records. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | Specifies the AWS region where Terraform will operate. | `string` | `"ap-northeast-2"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Additional Subject Alternative Names to include in the certificate. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to the ACM certificate. | `map(string)` | `{}` | no |
| <a name="input_transparency_logging_enabled"></a> [transparency\_logging\_enabled](#input\_transparency\_logging\_enabled) | Controls whether certificate transparency logging is enabled. | `bool` | `true` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Validation method for the ACM certificate. DNS is recommended. | `string` | `"DNS"` | no |
| <a name="input_validation_record_ttl"></a> [validation\_record\_ttl](#input\_validation\_record\_ttl) | TTL in seconds to apply to DNS validation records. | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of the provisioned ACM certificate. |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | Domain validation options returned by ACM. |
| <a name="output_validation_record_fqdns"></a> [validation\_record\_fqdns](#output\_validation\_record\_fqdns) | FQDNs of the DNS validation records created in Route 53. |
<!-- END_TF_DOCS -->
