# Repository Guidelines

## 프로젝트 구조와 모듈 구성
Terraform 학습용 예제는 환경별 디렉터리로 구분되며, 각 경로의 README는 terraform-docs로 생성된 입력·출력 정보를 제공합니다. 모든 작업은 해당 환경 디렉터리에서 실행하세요.
- `dev/`: EC2, EKS, Helm 등 실습 예제를 포함한 기본 작업 영역
- `stage/`, `prod/`: 스테이징·프로덕션 대상 코드 초안, 운영 시 동일한 패턴 유지
- `modules/`: `vpc`, `ec2`, `iam-role`, `security_group` 등 재사용 모듈 모음으로, 예제에서 `source = "../../modules/<name>"` 형태로 참조합니다
- `dev/template/`: 신규 실습 생성 시 복제 가능한 최소 템플릿을 제공합니다

## 빌드·테스트·개발 명령
Terraform 워크플로우는 예제별 디렉터리에서 실행하며, 원격 백엔드 설정 시 변수 파일을 명확히 구분합니다.
- `terraform init`: 공급자 플러그인 및 백엔드 초기화
- `terraform validate`: 구문 오류와 기본 규칙 검증, 커밋 전 필수
- `terraform plan -var-file dev.tfvars`: 변경 사항 시뮬레이션, 리뷰용 산출물 생성
- `terraform apply -auto-approve -var-file dev.tfvars`: 적용 단계, 실습에서는 auto-approve 대신 수동 승인을 권장
- `pre-commit run --all-files`: README 갱신 및 형식 검증 자동화

## Pre-commit/terraform-docs 운용 규칙
terraform-docs 훅은 README의 `<!-- BEGIN_TF_DOCS -->` 블록을 자동 갱신합니다. 커밋 시 훅이 수정한 README가 포함되지 않으면 충돌로 커밋이 실패할 수 있습니다. 다음 원칙을 지키세요.

- 항상 깨끗한 워킹 트리에서 커밋합니다. 부분 스테이징 상태에서 커밋을 시도하지 마세요.
- 코드 변경 후 문서와 함께 한 번에 커밋합니다. README 변경은 동일 커밋에 포함합니다.
- 커밋 전 아래 순서로 동작하세요.

```bash
# 1) 포맷/검증
terraform fmt -recursive
terraform validate

# 2) 문서 자동 갱신 (모든 경로 일괄)
pre-commit run --all-files

# 3) 변경 사항 모두 스테이징 (루트 README 포함)
git add -A

# 4) 커밋 (코드+문서 동시)
git commit -m "refactor: improve variable and output descriptions"
```

- `.terraform-docs.yaml`의 `recursive.enabled: true`와 `include-main: true`로 인해 하위 디렉터리 실행 시 루트 `README.md`도 함께 갱신됩니다. 반드시 루트 README까지 함께 스테이징하세요.

### 흔한 실패와 해결
- 증상: `Stashed changes conflicted with hook auto-fixes... Rolling back fixes...`
  - 원인: 훅이 수정한 파일(README 등)에 커밋되지 않은 변경이 남아 있어 복원 충돌 발생
  - 해결 절차:

```bash
# 워킹 트리 보호
git stash -u -k   # 인덱스(스테이징)는 유지하고 나머지 변경을 임시 저장

# 문서 싱크 및 스테이징
pre-commit run --all-files
git add -A

# 커밋 수행
git commit -m "docs: sync terraform-docs"

# 남은 작업 되돌리기
git stash pop

# 필요 시 다시 문서 싱크
pre-commit run --all-files && git add -A
```

- 가능한 회피: 커밋 시점에 워킹 트리를 깨끗하게 유지하고, 커밋 전에 `pre-commit run --all-files`를 먼저 수행하면 위 충돌을 대부분 예방할 수 있습니다.

#### 자주 보는 실패 메시지: terraform-docs가 Failed로 중단됨

증상 로그 예시:

```
[INFO] Stashing unstaged files to /home/USER/.cache/pre-commit/patch...
terraform-docs (modules).................................................Passed
terraform-docs (dev).....................................................Failed
- hook id: terraform-docs-go

terraform-docs (stage)...................................................Passed
terraform-docs (prod)....................................................Passed
[INFO] Restored changes from /home/USER/.cache/pre-commit/patch...
```

- 원인: `terraform-docs` 훅이 README를 자동 수정했지만, 해당 변경이 현재 커밋에 포함되지 않아 훅이 일단 실패(Failed)로 커밋을 중단합니다. 이 레포는 `.terraform-docs.yaml`의 `recursive.enabled: true`, `include-main: true` 설정으로 인해 하위 디렉터리에서 작업해도 여러 README가 함께 수정될 수 있습니다.
- 빠른 해결: 훅이 수정한 파일까지 모두 스테이징하여 다시 커밋합니다.

```bash
# 코드 변경과 문서 갱신을 한 번에 포함
git add -A
git commit -m "<type>: <summary>"

# 또는 문서만 갱신하는 커밋으로 분리
git add -A
git commit -m "docs: sync terraform-docs"
```

- 권장 절차(예방): 커밋 전에 아래 순서로 먼저 문서를 싱크하면 실패를 대부분 피할 수 있습니다.

```bash
terraform fmt -recursive && terraform validate
pre-commit run --all-files
git add -A && git commit -m "<type>: <summary>"
```

### 금지/예외 사항
- `SKIP=terraform-docs-go`로 훅을 건너뛰는 것은 비권장입니다. 반드시 같은 브랜치에서 즉시 `docs: sync terraform-docs` 커밋으로 문서를 동기화하세요.
- README 자동 생성 블록을 수동 편집하지 마세요. 수동 변경은 다음 훅 실행 시 덮어써집니다.

### 커밋 메시지 가이드(요약)
- 코드와 문서를 함께 변경: 핵심 변경 타입에 맞춰 하나로 커밋합니다.
  - 예) `refactor: improve variable and output descriptions`
- 문서만 재생성: `docs: sync terraform-docs`
- 메시지는 영어, 형태는 `type: summary`를 준수합니다.

## 코딩 스타일 및 네이밍 규칙
HCL은 `terraform fmt -recursive` 결과를 기준으로 두 칸 들여쓰기를 유지합니다.
- 리소스 이름은 `kebab-case`, 변수·출력은 `snake_case`로 작성합니다
- 모듈 입력 변수는 `variables.tf`, 출력은 `outputs.tf`에 정리하고, 불필요한 기본값을 피합니다
- 민감한 값은 `*.auto.tfvars` 대신 수동으로 관리되는 `example.tfvars` 템플릿과 환경 변수(`TF_VAR_`)를 사용하세요

## 테스트 가이드라인
자동화 테스트는 없으나 정적 검증과 계획 출력 검토가 최소 기준입니다.
- 변경 분마다 `terraform validate`와 `terraform plan`을 실행해 drift와 권한 오류를 사전에 확인합니다
- 모듈 수정 시 예제 디렉터리에서 최소 한 번 `plan`을 돌려 종속성 이상을 확인합니다
- 공급자나 모듈 버전을 갱신했다면 `terraform init -upgrade` 결과를 검토하고, 잠금 파일을 커밋합니다

## 커밋 및 PR 가이드라인
작업 단위를 작게 유지하고 코드·문서 동기화를 보장하세요.
- 커밋 메시지는 `feat:`, `fix:` 등 지정된 타입 뒤에 간결한 영어 요약을 작성합니다
- README나 출력이 변경되면 동일 커밋에 포함해 리뷰어가 diff를 한 번에 확인하도록 합니다
- 운영 절차나 규칙이 바뀌면 즉시 `AGENTS.md`를 업데이트하고 같은 커밋에 포함하세요
- PR 템플릿이 없다면 변경 의도, 주요 경로, 검증 결과(`plan` 출력 요약)를 본문에 기술하고, 필요 시 스크린샷이나 로그를 첨부하세요

## 로컬 캐시 및 아티팩트 관리
아래 로컬 캐시/툴링 아티팩트는 커밋 대상이 아니며, 이미 루트 `.gitignore`에서 무시됩니다. 필요 시 안전하게 삭제할 수 있고, 도구 실행 시 자동으로 재생성됩니다.

- `.gocache/`
- `.gomodcache/` (정확 표기: `gomodcache`, `gomodecache` 아님)
- `.gotmp/`
- `.pre-commit-cache/`
- `.xdg-cache/`

정리 명령 예시는 다음을 사용하세요.

```bash
# 전체 캐시 정리 (레포 루트에서)
rm -rf .gocache .gomodcache .gotmp .pre-commit-cache .xdg-cache

# Go 캐시만 정리
go clean -cache -testcache
go clean -modcache

# pre-commit 캐시 정리
pre-commit clean
# 또는
pre-commit gc
```

## 보안 및 상태 관리 팁
원격 상태와 자격 증명은 별도 워크스페이스에서 관리하여 실수로 커밋되지 않도록 합니다.
- `backend.tf` 수정 시 상태 이전 절차를 README에 문서화하고, 팀 합의를 거친 뒤 적용합니다
- AWS 자격 증명은 `aws-vault` 또는 SSO를 권장하며 환경 변수 직접 노출을 피합니다
- 실습 리소스는 `terraform destroy`로 즉시 정리하고, 비용 추적을 위해 태그(`Environment`, `Owner`)를 유지하세요
