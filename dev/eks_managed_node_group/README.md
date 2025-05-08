# Module을 사용하지 않고 EKS Cluster 배포해보기 (Managed Node Group)

## Todo

- [x] IAM Role for EKS Cluster  
- [x] EKS Cluster  
- [x] Access Entry  
<!-- - [x] Create Security Group   -->
<!-- - [ ] Create Launch Template   -->
- [x] Create EKS Managed Node Group  
- [x] ETCD Encryption  
- [ ] EKS Addon  
  - [x] CoreDNS
  - [x] VPC CNI
  - [x] kube-proxy
  - [x] Amazon EKS Pod Identity Agent
  - [x] EBS CSI Driver
    - [x] Pod Identity로 SA Role Binding
    - [x] storageClass 생성
  - [x] CSI Snapshot Controller
  - [x] ExternalDNS
    - [ ] Pod Identity #TODO
  - [x] Metrics Server
  <!-- - [ ] EFS CSI Driver -->
- [x] Max-Pod 확장 (VPC-CNI, Parameters)
  - [x] Custom Launch Template Node Group 생성 (Nodeadm, cloud-init)
  - [x] VPC-CNI `ENABLE_PREFIX_DELEGATION` ON (Kubernetes Provider)
  - [x] Remote Access 설정(Security Group)
  - [x] Security Group(Control Plane, Worker Node들과 통신)
- [ ] ArgoCD로 배포
  - [ ] AWS Load Balancer Controller
    - [ ] SA 생성 Kubernetes Provider
  - [ ] ExternalSecrets
  - [ ] Karpenter
- [ ] Terraform Code 모듈화
  - [ ] Cluster
    - [ ] KMS
  - [ ] Access Entry
  - [ ] Pod Identity
  - [ ] Node Group
  - [ ] Addon

## Thinking

- [x] bootstrap_cluster_create_admin_permissions 옵션을 true로 설정해 자동으로 클러스터 접근 권한을 부여할까 아니면 수동으로 부여할까?  -> `false`로 하고 직접 `Access Entry` 추가

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
