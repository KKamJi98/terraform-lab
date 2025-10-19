# Git 작업 로그

## 2025-10-20T00:43:42+09:00

- [준비] 저장소 상태 점검 및 변경 파일 목록을 확인했습니다.
- [git add] `git add -A`를 사용해 신규 `modules/access_entry`, `dev/eks_managed_node_group*` 리소스 추가와 `dev/eks_simple_example` 제거, 잠금 파일 업데이트 등을 모두 스테이징했습니다.
- [git commit] `git commit -m "feat(eks): add managed node group example"` 명령으로 신규 관리형 노드 그룹 예제와 `access_entry` 모듈 추가, 기존 예제 정리 내역을 하나의 커밋으로 기록했습니다.
- [git push] `git push origin main` 명령을 실행해 로컬 `main` 브랜치를 원격과 동기화했습니다.
- [pre-commit 메모] 기본 캐시 경로인 `~/.cache/pre-commit`이 샌드박스에서 쓰기 금지여서 `sqlite3.OperationalError`가 발생했고, 이어서 다른 저장소(`terraform-study`)에서 남아 있던 캐시가 깨져 `InvalidManifestError`가 재현됐습니다. 향후에는 커밋 전에 `PRE_COMMIT_HOME=$(pwd)/.local-pre-commit`과 `XDG_CACHE_HOME=$(pwd)/.local-cache`를 지정해 저장소 내부 경로를 사용하고, 문제가 생기면 `rm -rf .local-pre-commit .local-cache` 또는 `pre-commit clean`으로 캐시를 초기화해 충돌을 방지하세요.

## 2025-10-20T01:03:34+09:00

- [문서] `result.md`에 pre-commit 오류 원인과 재발 방지 절차를 보강했습니다.
- [git add] `git add result.md`로 변경된 로그 문서를 스테이징했습니다.
- [git commit] `git commit -m "docs: document pre-commit workaround"`로 로그 보강 내역을 별도 커밋에 기록했습니다.
- [git push] `git push origin main`으로 로그 업데이트 커밋을 원격 `main`에 반영했습니다.
