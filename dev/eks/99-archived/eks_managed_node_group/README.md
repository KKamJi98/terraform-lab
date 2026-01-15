# Module을 사용하지 않고 EKS Cluster 배포해보기 (Managed Node Group)

## Todo

- [x] IAM Role for EKS Cluster  
- [x] EKS Cluster  
- [x] Access Entry  
<!-- - [x] Create Security Group   -->
<!-- - [ ] Create Launch Template   -->
- [x] Create EKS Managed Node Group  
- [x] ETCD Encryption  
- [x] EKS Addon  
  - [x] CoreDNS
  - [x] VPC CNI
  - [x] kube-proxy
  - [x] Amazon EKS Pod Identity Agent
  - [x] EBS CSI Driver (현재 바깥으로 잠깐 빼둠)
    - [x] Pod Identity로 SA Role Binding
    - [x] storageClass 생성
  - [x] CSI Snapshot Controller
  - [x] Metrics Server
  <!-- - [ ] EFS CSI Driver -->
- [x] Max-Pod 확장 (VPC-CNI, Parameters)
  - [x] Custom Launch Template Node Group 생성 (Nodeadm, cloud-init)
  - [x] VPC-CNI `ENABLE_PREFIX_DELEGATION` ON (Kubernetes Provider)
  - [x] Remote Access 설정(Security Group)
  - [x] Security Group(Control Plane, Worker Node들과 통신)
- [x] ArgoCD로 배포
  - [x] AWS Load Balancer Controller
    - [x] SA 생성 Kubernetes Provider (Helm 배포할 때 생성하도록 변경)
  - [x] ExternalSecrets
    - [x] Pod Identity #TODO
  - [x] ExternalDNS
    - [x] Pod Identity #TODO
- [ ] Terraform Code 모듈화
  - [ ] Cluster
    - [ ] KMS
  - [ ] Access Entry
  - [ ] Pod Identity
  - [ ] Node Group
  - [ ] Addon

## Memo

- [x] bootstrap_cluster_create_admin_permissions 옵션을 true로 설정해 자동으로 클러스터 접근 권한을 부여할까 아니면 수동으로 부여할까?  -> `false`로 하고 직접 `Access Entry` 추가
- [x] kubernetes 리소스를 삭제하기 전 access entry를 삭제해 `Unauthorized` 문제 발생 건 해결 (kubernetes provider를 사용하는 디렉터리 분리)

## Access Entry lists

### AmazonEKSClusterAdminPolicy

일반적으로 클러스터 전체 범위에 적용됨

- ARN: arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy
- 기능: 클러스터에 대한 관리자 액세스 권한을 부여하며, 기본 제공되는 cluster-admin 역할과 동등한 권한 제공

### AmazonEKSAdminPolicy

- ARN: arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy
- 기능: 기본 제공되는 admin 역할과 동등한 권한 제공

### AmazonEKSAdminViewPolicy

- ARN: arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy
- 기능: 클러스터의 모든 리소스를 나열/조회할 수 있는 권한 제공 (Kubernetes Secrets 포함)

### AmazonEKSEditPolicy

- ARN: arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy
- 기능: 대부분의 Kubernetes 리소스를 편집할 수 있는 권한 제공

### AmazonEKSViewPolicy

- ARN: arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy
- 기능: 대부분의 Kubernetes 리소스를 조회할 수 있는 권한 제공

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.cluster_admin_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.kkamji_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_access_policy_association.kkamji_cluster_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.metrics_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.pod_identity_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.snapshot_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.kkamji_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.eks_managed_node_group_custom_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_pod_identity_association.aws_load_balancer_controller_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.external_dns_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.external_secrets_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.aws_load_balancer_controller_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_load_balancer_controller_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi_driver_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.external_secrets_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.kkamji_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.kkamji_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_load_balancer_controller_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_secrets_parameter_store_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_secrets_secrets_manager_pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kkamji_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.kkamji_arm64_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.remote_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kkamji_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.kkamji_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.eks_cluster_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.eks_al2023_amd64_ami_release_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.eks_al2023_arm64_ami_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.eks_al2023_arm64_ami_release_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.basic](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | CIDR blocks to allow public access to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to create resources in | `string` | `"ap-northeast-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
<!-- END_TF_DOCS -->