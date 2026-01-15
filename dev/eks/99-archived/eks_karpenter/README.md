# EKS Cluster with Karpenter

## How to Delete EKS Cluster

Follow these steps in order to properly delete an EKS cluster with Karpenter:

1. Delete all NodeClaims
   ```bash
   kubectl delete nodeclaims --all
   ```

2. Delete all NodePools
   ```bash
   kubectl delete nodepools --all
   ```

3. Delete all EC2NodeClasses
   ```bash
   kubectl delete ec2nodeclasses --all
   ```

4. Run Terraform destroy
   ```bash
   terraform destroy -auto-approve
   ```

## Cleanup Script

For convenience, you can use the `destroy.sh` script in this directory to perform all the cleanup steps in the correct order.

```bash
# Run the cleanup script
./destroy.sh
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.9 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.99.1 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.36 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecrpublic_authorization_token) | data source |
| [terraform_remote_state.basic](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The AWS region to launch the server in | `string` | `"ap-northeast-2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->