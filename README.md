# Terraform Study Repository

Terraform 학습·실습 내용을 정리하는 저장소입니다.

## 레포지토리 구조

```text
.
├── README.md
├── .pre-commit-config.yaml      # terraform-docs 자동화 훅 설정
├── .terraform-docs.yaml         # terraform-docs 전역 설정
├── dev                          # 개발 환경 예제들
│   ├── ec2                      # EC2 예제 및 스크립트
│   ├── auto_scaling_group       # ASG 예제
│   ├── eks_managed_node_group   # EKS 관리형 노드 그룹
│   ├── eks_self_managed_node_group # EKS 자체 관리형 노드 그룹
│   ├── eks_simple               # 간단한 EKS 클러스터 예제
│   ├── eks_karpenter            # Karpenter 예제
│   ├── helm                     # Helm 예제
│   ├── kubernetes               # K8s 리소스 예제
│   ├── s3                       # S3 예제
│   ├── acm                      # ACM 예제
│   ├── import_ec2               # 기존 리소스 import 예제
│   ├── template                 # 템플릿 예제
│   └── kcd-2025-lab             # 워크숍/랩 예제
├── modules                      # 재사용 가능한 모듈 모음
│   ├── ec2 | iam-role | security_group | vpc
├── stage                        # 스테이징 환경 코드 (예정/진행)
└── prod                         # 프로덕션 환경 코드 (예정/진행)
```

## 학습 내용

다음과 같은 AWS 리소스 및 운영 주제에 대한 Terraform 실습을 포함합니다.

- VPC 네트워크 구성, 라우팅, NAT/IGW
- EC2/ASG 배포와 사용자 데이터, 스크립트 관리
- 보안 그룹, IAM 역할/정책 관리
- EKS 클러스터 구성(관리형/자체 관리형), 애드온, IRSA
- Helm을 통한 배포 및 K8s 리소스 관리
- HCP Terraform과의 연계(plan/apply/destroy)

## 환경별 구성

- `dev`: 개발/실습용 예제 모음
- `stage`: 스테이징 환경 코드 (예정/진행)
- `prod`: 프로덕션 환경 코드 (예정/진행)

## 모듈 구성

공통으로 재사용할 리소스를 `modules` 디렉터리에 모듈 형태로 관리합니다. 각 모듈과 예제 경로의 README는 terraform-docs로 자동 갱신됩니다.

## 개발 도구 및 자동화

- **terraform-docs**: Terraform 코드로부터 Inputs/Outputs/Providers/Resources 문서를 자동 생성합니다.
- **pre-commit**: 커밋 전에 terraform-docs를 실행해 각 경로의 README를 최신 상태로 유지합니다.

### 설치

- pre-commit
  - macOS: `brew install pre-commit`
  - Linux: `pipx install pre-commit` 또는 `pip install --user pre-commit`
  - Windows: `pipx install pre-commit` 또는 `pip install --user pre-commit`
- terraform-docs (선택, 수동 실행 시 필요)
  - macOS: `brew install terraform-docs`
  - Linux: GitHub Releases에서 바이너리 다운로드 또는 패키지 매니저 사용
  - Windows: `choco install terraform-docs` 또는 스쿱/수동 설치

권장: Python 툴은 `pipx`로, 시스템 패키지는 각 OS의 패키지 매니저로 설치하세요.

### pre-commit 설정 및 실행

- 최초 1회: `pre-commit install`
- 전체 훅 수동 실행: `pre-commit run --all-files`
- 자동 업데이트(버전 갱신): `pre-commit autoupdate`

현재 설정(.pre-commit-config.yaml)은 아래 경로들에서 terraform-docs를 재귀적으로 실행합니다.

- `./modules`
- `./dev`
- `./stage`
- `./prod`

### terraform-docs 수동 실행

pre-commit 대신 필요 시 직접 실행할 수 있습니다.

- 루트(이 파일): `terraform-docs --config .terraform-docs.yaml .`
- 모듈 전체: `terraform-docs --config .terraform-docs.yaml ./modules`
- 개발 예제: `terraform-docs --config .terraform-docs.yaml ./dev`
- 스테이징: `terraform-docs --config .terraform-docs.yaml ./stage`
- 프로덕션: `terraform-docs --config .terraform-docs.yaml ./prod`

README에 아래 주입 마커가 있어야 자동 갱신됩니다(이미 각 경로의 README에 적용됨).

```markdown
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
```

## Pre-commit/terraform-docs 운용 규칙

terraform-docs 훅은 README의 `<!-- BEGIN_TF_DOCS -->` 블록을 자동 갱신합니다. 커밋 시 훅이 수정한 README가 포함되지 않으면 충돌로 커밋이 실패할 수 있으므로 아래 원칙을 따르세요.

- 항상 깨끗한 워킹 트리에서 커밋합니다. 부분 스테이징 상태에서 커밋을 시도하지 않습니다.
- 코드 변경 후 문서와 함께 한 번에 커밋합니다. README 변경은 동일 커밋에 포함합니다.
- `.terraform-docs.yaml`의 `recursive.enabled: true` 및 `include-main: true`로 인해 하위 경로에서 실행해도 루트 `README.md`가 갱신됩니다. 루트 README까지 반드시 함께 스테이징합니다.

### 표준 흐름

```bash
# 포맷/검증
terraform fmt -recursive
terraform validate

# 문서 자동 갱신 (전 경로 일괄)
pre-commit run --all-files

# 변경 사항 모두 스테이징 (루트 README 포함)
git add -A

# 커밋 (코드+문서 동시)
git commit -m "refactor: improve variable and output descriptions"
```

### 흔한 실패와 해결

- 증상: `Stashed changes conflicted with hook auto-fixes... Rolling back fixes...`
  - 원인: 훅이 수정한 파일(README 등)에 커밋되지 않은 변경이 남아 있어 복원 충돌이 발생함
  - 해결:

```bash
# 워킹 트리 보호
git stash -u -k   # 인덱스(스테이징)는 유지, 나머지 변경 임시 저장

# 문서 싱크 및 스테이징
pre-commit run --all-files
git add -A

# 커밋 수행 (문서만 재생성 시)
git commit -m "docs: sync terraform-docs"

# 남은 작업 되돌리기
git stash pop

# 필요 시 다시 문서 싱크
pre-commit run --all-files && git add -A
```

### 금지/예외 사항

- `SKIP=terraform-docs-go`로 훅을 임의로 건너뛰는 것은 비권장입니다. 부득이한 경우에도 같은 브랜치에서 즉시 `docs: sync terraform-docs` 커밋으로 문서를 동기화해야 합니다.
- README 자동 생성 블록은 수동 편집하지 않습니다. 수동 변경은 다음 훅 실행 시 덮어써집니다.

### 커밋 메시지 가이드(요약)

- 코드와 문서를 함께 변경: 변화의 성격에 맞춰 하나로 커밋합니다. 예: `refactor: improve variable and output descriptions`
- 문서만 재생성: `docs: sync terraform-docs`
- 메시지는 영어, 형식은 `type: summary`를 준수합니다.

## 운영 방식

HCP Terraform을 통해 `terraform plan`, `apply`, `destroy` 작업을 수행합니다. 로컬 실습 시에는 각 예제 경로에서 일반적인 Terraform 워크플로우(`init` → `validate` → `plan` → `apply`)를 사용하세요.

## Terraform Docs 출력(루트)

아래 블록은 terraform-docs로 주입되며, 필요 시 수동 업데이트 가능합니다.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## 향후 계획

- 다양한 AWS 서비스에 대한 Terraform 실습 확대
- 멀티 리전 배포 전략 및 Best Practice 정리
- 상태 관리/백엔드 전략 고도화
