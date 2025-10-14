test-path: `dev/eks_managed_node_group`

## Reference

- 참고 문서
    - https://docs.aws.amazon.com/eks/latest/best-practices/identity-and-access-management.html
    - https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-eks-cluster-accessconfig.html
    - https://docs.aws.amazon.com/eks/latest/userguide/setting-up-access-entries.html
    - https://aws.amazon.com/ko/blogs/containers/a-deep-dive-into-simplified-amazon-eks-access-management-controls
- GitHub Issue
    - https://github.com/hashicorp/terraform-provider-aws/issues/38967
- EKS Terraform Reference 및 모듈
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
    - https://github.com/terraform-aws-modules/terraform-aws-eks
- Config Map 모드일 때  클러스터를 생성한 사용자에게 `system:master` 권한이 부여된다
    - https://docs.aws.amazon.com/eks/latest/best-practices/identity-and-access-management.html
        
        > When you create a cluster, the AWS Identity and Access Management (IAM) principal that creates the cluster is automatically granted `system:masters` permissions in the cluster's RBAC configuration.
        > 
    - https://docs.aws.amazon.com/eks/latest/userguide/auth-configmap.html
        
        > When `bootstrap_cluster_creator_admin_permissions` is `true`, the principal that created the cluster automatically has administrative privileges (mapped to `system:masters`) in the Kubernetes RBAC.
        > 

## 1. authentication_mode 만 "API_AND_CONFIG_MAP" 으로 두고 클러스터 생성 했을 때

> 처음 클러스터를 생성하면서 `bootstrap_cluster_creator_admin_permission`을 지정하지 않고 `authentication_mode`만 `"API_AND_CONFIG_MAP"`로 두었을 때 어떻게 동작하는지 확인
> 

결론: 클러스터를 생성에 사용된 IAM Role이 Access Entry에 포함되지 않아 접근 불가

```bash
## aws_eks_cluster 내 access_config 설정 내용
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    # bootstrap_cluster_creator_admin_permissions = true # 미지정 (주석 처리)
  }

## 생성된 클러스터의 Terraform State 확인
❯ tf state show aws_eks_cluster.kkamji_cluster | grep access_config -A3
    access_config {
        authentication_mode                         = "API_AND_CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = false
    }

## 클러스터내 리소스 접근 여부 확인
❯ aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-al2023 --alias kkamji-al2023
Updated context kkamji-al2023 in /home/kkamji/.kube/config

❯ kubectl auth can-i '*' '*' --all-namespaces
no

❯ kubectl get po -A
E1014 23:17:09.399061  896286 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
E1014 23:17:10.230679  896286 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
E1014 23:17:11.069704  896286 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
E1014 23:17:11.846800  896286 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
E1014 23:17:12.676396  896286 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
error: You must be logged in to the server (the server has asked for the client to provide credentials)

## authentication_mode 변경 테스트
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true # false -> true
  }
  
## Plan 결과 (클러스터를 재생성하려고 함)
❯ terraform plan
...
  # aws_eks_cluster.kkamji_cluster must be replaced
-/+ resource "aws_eks_cluster" "kkamji_cluster" {
...
      ~ access_config {
          ~ bootstrap_cluster_creator_admin_permissions = false -> true # forces replacement
            # (1 unchanged attribute hidden)
        }
```

## 2. access_config 를 지정하지 않고 클러스터를 생성했을 때

> `access_config`에 아무 설정을 하지 않고 생성한 클러스터에 `access_config`가 어떻게 설정되는지 확인
> 
- https://docs.aws.amazon.com/eks/latest/best-practices/identity-and-access-management.html
    
    <aside>
    💡
    
    ### **Create cluster using an automated process**
    
    As seen in earlier steps, when creating an Amazon EKS cluster, if not using the using `API_AND_CONFIG_MAP` or `API` authentication mode, and not opting out to delegate `cluster-admin` permissions to the cluster creator, the IAM entity user or role, such as a federated user that creates the cluster, is automatically granted `system:masters` permissions in the cluster’s RBAC configuration. Even being a best practice to remove this permission, as described [here](https://docs.aws.amazon.com/eks/latest/best-practices/identity-and-access-management.html#iam-cluster-creator) if using the `CONFIG_MAP` authentication method, relying on `aws-auth` ConfigMap, this access cannot be revoked. Therefore it is a good idea to create the cluster with an infrastructure automation pipeline tied to dedicated IAM role, with no permissions to be assumed by other users or entities and regularly audit this role’s permissions, policies, and who has access to trigger the pipeline. Also, this role should not be used to perform routine actions on the cluster, and be exclusively used to cluster level actions triggered by the pipeline, via SCM code changes for example.
    
    </aside>
    
- https://docs.aws.amazon.com/eks/latest/userguide/auth-configmap.html
    
    <aside>
    💡
    
    ## **Add IAM principals to your Amazon EKS cluster**
    
    When you create an Amazon EKS cluster, the [IAM principal](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html#iam-term-principal) that creates the cluster is automatically granted `system:masters` permissions in the cluster’s role-based access control (RBAC) configuration in the Amazon EKS control plane. This principal doesn’t appear in any visible configuration, so make sure to keep track of which principal originally created the cluster. To grant additional IAM principals the ability to interact with your cluster, edit the `aws-auth ConfigMap` within Kubernetes and create a Kubernetes `rolebinding` or `clusterrolebinding` with the name of a `group` that you specify in the `aws-auth ConfigMap`.
    
    </aside>
    

```bash
## aws_eks_cluster 의 access_config 주석처리 후 EKS Cluster 생성 (access_config 미지정)
  # access_config {
  #   authentication_mode                         = "API_AND_CONFIG_MAP"
  #   bootstrap_cluster_creator_admin_permissions = true # 클러스터를 생성한 IAM 사용자 또는 역할에게 자동으로 Kubernetes 클러스터에 대한 전체 관리 권한(admin)을 부여할지 여부 (false로 설정하면, 사용자 또는 역할에게 IAM 정책을 직접 부여해야 함)
  # }
  
## 생성된 클러스터의 Terraform State 확인
❯ tf state show aws_eks_cluster.kkamji_cluster | grep access_config -A3
    access_config {
        authentication_mode                         = "CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = true
    }
    
## 클러스터내 리소스 접근 여부 확인 (접근 가능)
❯ aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-al2023 --alias kkamji-al2023
Updated context kkamji-al2023 in /home/kkamji/.kube/config

❯ kubectl auth can-i '*' '*' --all-namespaces
yes

❯ kubectl get po -A
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   aws-node-n6pd8                         2/2     Running   0          34m
kube-system   aws-node-zjhqq                         2/2     Running   0          34m
kube-system   coredns-844d8f59bb-8qsh9               1/1     Running   0          37m
kube-system   coredns-844d8f59bb-kzfqx               1/1     Running   0          37m
kube-system   ebs-csi-controller-544db5c4d5-88rrt    6/6     Running   0          35m
kube-system   ebs-csi-controller-544db5c4d5-jfb6v    6/6     Running   0          35m
kube-system   ebs-csi-node-l7cpx                     3/3     Running   0          34m
kube-system   ebs-csi-node-qpjsd                     3/3     Running   0          34m
kube-system   eks-pod-identity-agent-5p862           1/1     Running   0          34m
kube-system   eks-pod-identity-agent-gds5m           1/1     Running   0          34m
kube-system   kube-proxy-6lz5r                       1/1     Running   0          34m
kube-system   kube-proxy-d5bjt                       1/1     Running   0          34m
kube-system   snapshot-controller-567d64fdc6-hk4dk   1/1     Running   0          35m
kube-system   snapshot-controller-567d64fdc6-w9s47   1/1     Running   0          35m
```

## 3. CONFIG_MAP → API_AND_CONFIG_MAP으로 변경 테스트

> `access_config`에 아무 설정을 하지 않고 클러스터를 생성했을 때 access_config가 어떻게 설정되는지 확인
> 

```bash
## 위 에서 생성한 클러스터를 기반으로 테스트 "2. access_config 를 지정하지 않고 클러스터를 생성했을 때"

## 현재 Terraform State 확인
❯ tf state show aws_eks_cluster.kkamji_cluster | grep access_config -A3
    access_config {
        authentication_mode                         = "CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = true
    }

## 1. authentication_mode 만 "API_AND_CONFIG_MAP" 으로 수정한 뒤 Plan
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    # bootstrap_cluster_creator_admin_permissions = true # 주석 처리 (default 값이 false이기 때문에 클러스터 재생성 예상)
  }

## Plan 결과 (1) - 재생성
...
  # aws_eks_cluster.kkamji_cluster must be replaced
-/+ resource "aws_eks_cluster" "kkamji_cluster" {
...
      ~ access_config {
          ~ authentication_mode                         = "CONFIG_MAP" -> "API_AND_CONFIG_MAP"
          - bootstrap_cluster_creator_admin_permissions = true -> null # forces replacement
        }

## 2. authentication_mode = "API_AND_CONFIG_MAP", bootstrap_cluster_creator_admin_permissions = false 로 수정 한 뒤 Plan
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false # true -> false 수정 (현재 Terraform State 값과 다르기 때문에 클러스터 재생성 에상)
  }
  
## Plan 결과 (2) - 재생성
...
  # aws_eks_cluster.kkamji_cluster must be replaced
-/+ resource "aws_eks_cluster" "kkamji_cluster" {
...
      ~ access_config {
          ~ authentication_mode                         = "CONFIG_MAP" -> "API_AND_CONFIG_MAP"
          ~ bootstrap_cluster_creator_admin_permissions = true -> false # forces replacement
        }
        
## 3. authentication_mode = "API_AND_CONFIG_MAP", bootstrap_cluster_creator_admin_permissions = true 로 수정 한 뒤 Plan
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true # 주석 해제 (현재 Terraform State 값과 동일하기 때문에 클러스터 재생성 X 에상)
  }

## Plan 결과 (3) - Inplace Update
...
  # aws_eks_cluster.kkamji_cluster will be updated in-place
  ~ resource "aws_eks_cluster" "kkamji_cluster" {
...
      ~ access_config {
          ~ authentication_mode                         = "CONFIG_MAP" -> "API_AND_CONFIG_MAP"
            # (1 unchanged attribute hidden)
        }
```

## 추가정보

```bash
# bootstrap_cluster_creator_admin_permissions = true로 두었을 때 동일한 Access Entry를 따로 추가해주면 에러남

 Error: creating EKS Access Entry (kkamji-al2023:arn:aws:iam::<ACCOUNT_ID>:user/KKamJi2024): operation error EKS: CreateAccessEntry, https response error StatusCode: 409, RequestID: a64d09e7-3d11-44ca-8500-935449a95262, ResourceInUseException: The specified access entry resource is already in use on this cluster.
│
│   with aws_eks_access_entry.cluster_admin_access,
│   on 00_access_entry.tf line 26, in resource "aws_eks_access_entry" "cluster_admin_access":
│   26: resource "aws_eks_access_entry" "cluster_admin_access" {
│
╵
```
