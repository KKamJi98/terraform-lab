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
- 애드온 `coredns`, `kube-proxy`, `vpc-cni(프리픽스 위임)`
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
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
| [kubernetes_storage_class_v1.gp3_east](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.gp3_west](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [terraform_remote_state.basic](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region for both clusters | `string` | `"ap-northeast-2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
