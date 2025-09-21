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

## 보안 및 상태 관리 팁
원격 상태와 자격 증명은 별도 워크스페이스에서 관리하여 실수로 커밋되지 않도록 합니다.
- `backend.tf` 수정 시 상태 이전 절차를 README에 문서화하고, 팀 합의를 거친 뒤 적용합니다
- AWS 자격 증명은 `aws-vault` 또는 SSO를 권장하며 환경 변수 직접 노출을 피합니다
- 실습 리소스는 `terraform destroy`로 즉시 정리하고, 비용 추적을 위해 태그(`Environment`, `Owner`)를 유지하세요
