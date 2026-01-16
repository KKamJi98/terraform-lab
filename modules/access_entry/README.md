<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries to add to the cluster | <pre>map(object({<br/>    kubernetes_groups = list(string)<br/>    principal_arn     = string<br/>    type              = string<br/>    user_name         = string<br/>    tags              = map(string)<br/>    policy_associations = map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = list(string)<br/>        type       = string<br/>      })<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_entries"></a> [access\_entries](#output\_access\_entries) | Map of access entries created and their attributes |
| <a name="output_access_policy_associations"></a> [access\_policy\_associations](#output\_access\_policy\_associations) | Map of eks cluster access policy associations created and their attributes |
<!-- END_TF_DOCS -->