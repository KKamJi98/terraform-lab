<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.28.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kkamji_security_group"></a> [kkamji\_security\_group](#module\_kkamji\_security\_group) | ../../modules/security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.external_secrets_parameter_store_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.external_secrets_secrets_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_key_pair.my_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_key_string"></a> [public\_key\_string](#input\_public\_key\_string) | The public key to use for SSH access | `string` | `"ssh-rsa FAKE_PUBLIC_KEY_PLACEHOLDER"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to launch the server in | `string` | `"ap-northeast-2"` | no |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | The port the server will use for HTTP requests | `number` | `8080` | no |
| <a name="input_user_names"></a> [user\_names](#input\_user\_names) | IAM user name | `list(string)` | <pre>[<br/>  "secrets_manager",<br/>  "external_dns"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_dns_user_arn"></a> [external\_dns\_user\_arn](#output\_external\_dns\_user\_arn) | The ARN of the external DNS user |
| <a name="output_external_secrets_user_arn"></a> [external\_secrets\_user\_arn](#output\_external\_secrets\_user\_arn) | The ARN of the external secrets user |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | The name of the key pair used to launch the server |
| <a name="output_kkamji_security_group_id"></a> [kkamji\_security\_group\_id](#output\_kkamji\_security\_group\_id) | The ID of the application security group |
<!-- END_TF_DOCS -->