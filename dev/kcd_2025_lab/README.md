# kcd-2025-lab

Terraform로 AWS에 Amazon EKS 클러스터 2개(east/west) 구성

## 요구 사항

- Terraform `>= 1.5.0`
- AWS CLI v2, `kubectl`, `helm`
- Terraform Cloud Org `KKamJi`
  - Backend Workspace: `kcd-2025-lab`
  - Remote State Workspace: `basic`

## 빠른 시작

```bash
terraform login
terraform init
terraform plan
terraform apply
```

## 변수

- `region`: 기본값 `ap-northeast-2` (CLI `-var`, 또는 `TF_VAR_region`)

## 클러스터 접근

```bash
aws eks update-kubeconfig --name kkamji-east --region ${TF_VAR_region:-ap-northeast-2}
aws eks update-kubeconfig --name kkamji-west --region ${TF_VAR_region:-ap-northeast-2}
kubectl config get-contexts
```

## 구성

- EKS 모듈 `terraform-aws-modules/eks/aws ~> 21.0`
- Kubernetes `1.33`
- 노드그룹 `t4g.small` 2개(고정)
- 애드온 `coredns`, `kube-proxy`, `vpc-cni(프리픽스 위임)`, `aws-ebs-csi-driver(Pod Identity)`, `metrics-server`, `external-dns(Pod Identity)`
- 네트워킹: 원격 상태(`basic`)의 `vpc_id`, `public_subnet_ids`

## 원격 상태

- `vpc_id`, `public_subnet_ids`, `key_pair_name` 필요

## Terraform Docs

terraform-docs로 아래 영역 자동 주입

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.11.0 |
| <a name="provider_kubernetes.east"></a> [kubernetes.east](#provider\_kubernetes.east) | 2.38.0 |
| <a name="provider_kubernetes.west"></a> [kubernetes.west](#provider\_kubernetes.west) | 2.38.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_east"></a> [eks\_east](#module\_eks\_east) | terraform-aws-modules/eks/aws | ~> 21.0 |
| <a name="module_eks_west"></a> [eks\_west](#module\_eks\_west) | terraform-aws-modules/eks/aws | ~> 21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ebs_csi_driver_pod_identity_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi_driver_pod_identity_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns_pod_identity_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns_pod_identity_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver_pod_identity_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver_pod_identity_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns_policy_attach_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns_policy_attach_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_storage_class_v1.gp3_east](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.gp3_west](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [terraform_remote_state.basic](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries_east"></a> [access\_entries\_east](#input\_access\_entries\_east) | EKS east cluster access entries map | <pre>map(object({<br/>    kubernetes_groups = optional(list(string))<br/>    principal_arn     = string<br/>    type              = optional(string, "STANDARD")<br/>    user_name         = optional(string)<br/>    tags              = optional(map(string), {})<br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = optional(list(string))<br/>        type       = string<br/>      })<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_access_entries_west"></a> [access\_entries\_west](#input\_access\_entries\_west) | EKS west cluster access entries map | <pre>map(object({<br/>    kubernetes_groups = optional(list(string))<br/>    principal_arn     = string<br/>    type              = optional(string, "STANDARD")<br/>    user_name         = optional(string)<br/>    tags              = optional(map(string), {})<br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = optional(list(string))<br/>        type       = string<br/>      })<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for both clusters | `string` | `"ap-northeast-2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
