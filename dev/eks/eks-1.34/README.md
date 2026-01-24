<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.28.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.28.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | ../../../modules/eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.karpenter_instance_state_change](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.karpenter_rebalance](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.karpenter_scheduled_change](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.karpenter_spot_interruption](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.karpenter_instance_state_change](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.karpenter_rebalance](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.karpenter_scheduled_change](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.karpenter_spot_interruption](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_eks_pod_identity_association.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.external_dns](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role) | resource |
| [aws_iam_role.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role) | resource |
| [aws_iam_role.karpenter_node](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.karpenter_node](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sqs_queue.karpenter_interruption](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.karpenter_interruption](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter_controller_assume](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter_interruption_queue](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/data-sources/region) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | `"kkamji-eks-34"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"ap-northeast-2"` | no |
| <a name="input_vpc_state_organization"></a> [vpc\_state\_organization](#input\_vpc\_state\_organization) | Terraform Cloud organization for VPC remote state | `string` | `"kkamji-lab"` | no |
| <a name="input_vpc_state_workspace"></a> [vpc\_state\_workspace](#input\_vpc\_state\_workspace) | Terraform Cloud workspace name for VPC remote state | `string` | `"dev-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_load_balancer_controller_role_arn"></a> [aws\_load\_balancer\_controller\_role\_arn](#output\_aws\_load\_balancer\_controller\_role\_arn) | AWS Load Balancer Controller IAM role name |
| <a name="output_aws_load_balancer_controller_role_name"></a> [aws\_load\_balancer\_controller\_role\_name](#output\_aws\_load\_balancer\_controller\_role\_name) | AWS Load Balancer Controller IAM role name |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | EKS OIDC issuer URL |
| <a name="output_karpenter_controller_role_arn"></a> [karpenter\_controller\_role\_arn](#output\_karpenter\_controller\_role\_arn) | Karpenter controller IAM role ARN |
| <a name="output_karpenter_controller_role_name"></a> [karpenter\_controller\_role\_name](#output\_karpenter\_controller\_role\_name) | Karpenter controller IAM role name |
| <a name="output_karpenter_interruption_queue_arn"></a> [karpenter\_interruption\_queue\_arn](#output\_karpenter\_interruption\_queue\_arn) | Karpenter interruption SQS queue ARN |
| <a name="output_karpenter_interruption_queue_name"></a> [karpenter\_interruption\_queue\_name](#output\_karpenter\_interruption\_queue\_name) | Karpenter interruption SQS queue name |
| <a name="output_karpenter_node_role_name"></a> [karpenter\_node\_role\_name](#output\_karpenter\_node\_role\_name) | Karpenter node IAM role name |
<!-- END_TF_DOCS -->
