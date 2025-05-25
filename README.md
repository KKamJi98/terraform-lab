# Terraform Study Repository

Terraform 학습 과정에서 실습한 내용을 정리하고 저장하는 공간.

## 레포지토리 구조

```
.
├── README.md          # 프로젝트 설명 문서
├── dev                # 개발 환경 관련 Terraform 코드
│   ├── eks_managed_node_group    # EKS 관리형 노드 그룹 실습
│   ├── eks_self_managed_node_group  # EKS 자체 관리형 노드 그룹 실습
│   ├── eks_simple     # 간단한 EKS 클러스터 구성 실습
│   └── helm-test      # Helm 차트 배포 테스트
├── modules            # 재사용 가능한 Terraform 모듈
│   ├── ec2            # EC2 인스턴스 생성 모듈
│   ├── iam-role       # IAM 역할 생성 모듈
│   ├── security_group # 보안 그룹 생성 모듈
│   └── vpc            # VPC 네트워크 구성 모듈
├── prod               # 프로덕션 환경 관련 Terraform 코드 (예정)
└── stage              # 스테이징 환경 관련 Terraform 코드 (예정)
```

## 학습 내용

이 레포지토리에서 다음과 같은 AWS 리소스 관리에 대한 Terraform 실습 진행:

- VPC 네트워크 구성
- EC2 인스턴스 생성 및 관리
- 보안 그룹 설정
- IAM 역할 및 정책 관리
- EKS(Elastic Kubernetes Service) 클러스터 구성
  - 관리형 노드 그룹
  - 자체 관리형 노드 그룹
  - 애드온 설치
- Helm을 이용한 Kubernetes 애플리케이션 배포

## 환경별 구성

- `dev`: 개발 환경 리소스 구성
- `stage`: 스테이징 환경 리소스 구성 (예정)
- `prod`: 프로덕션 환경 리소스 구성 (예정)

## 모듈 구성

재사용 가능한 모듈을 `modules` 디렉토리에 구성하여 환경별로 필요한 리소스를 효율적으로 생성할 수 있도록 구성.

## 운영 방식

HCP Terraform을 통해 terraform plan, apply, destroy 작업 수행 중.

## 향후 계획

- 다양한 AWS 서비스에 대한 Terraform 실습 추가
- 멀티 리전 배포 전략 구현
- 상태 관리 전략 개선
