#!/usr/bin/env bash
# file: tf-run.sh (tfenv 대응)
set -euo pipefail

# --- tfenv PATH 보정 (로그인 셸이 아닐 때 대비) ---
export PATH="$HOME/.tfenv/bin:$PATH"

# --- terraform 실행 파일 결정: tfenv shim 우선 ---
TF_BIN="${TF_BIN:-}"
if [[ -z "${TF_BIN}" ]]; then
  if command -v terraform >/dev/null 2>&1; then
    TF_BIN="$(command -v terraform)"   # 보통 ~/.tfenv/bin/terraform (shim)
  else
    echo "[ERR] terraform 실행 파일을 찾지 못했습니다. tfenv 설치/PATH 확인." >&2
    echo "      예) echo 'export PATH=\$HOME/.tfenv/bin:\$PATH' >> ~/.zshrc" >&2
    exit 127
  fi
fi

# --- 버전 선택 확인(.terraform-version 또는 tfenv use) ---
# 프로젝트 루트에 .terraform-version이 있으면 tfenv가 자동 선택
# 필요 시: tfenv install && tfenv use

TIME_BIN="/usr/bin/time"   # macOS는 gtime 사용 (아래 참고)

RUN_ID="$(date +'%Y%m%d-%H%M%S')"
LOG_DIR="./logs/${RUN_ID}"
mkdir -p "${LOG_DIR}"

DESTROY_LOG="${LOG_DIR}/destroy.log"
APPLY_LOG="${LOG_DIR}/apply.log"
DESTROY_TIME="${LOG_DIR}/destroy.time.txt"
APPLY_TIME="${LOG_DIR}/apply.time.txt"
SUMMARY="${LOG_DIR}/summary.txt"

ts_or_cat() { command -v ts >/dev/null 2>&1 && ts '%Y-%m-%d %H:%M:%.S' || cat; }

echo "== Run ID : ${RUN_ID}"
echo "== TF_BIN : ${TF_BIN}"
echo "== TF_VER : $("$TF_BIN" -version | head -n1 || true)"
echo "== Logs   : ${LOG_DIR}"

START_DESTROY=$(date +%s)
{ "${TIME_BIN}" -v -o "${DESTROY_TIME}" "$TF_BIN" destroy -auto-approve 2>&1 \
  | ts_or_cat | tee "${DESTROY_LOG}"; } || DESTROY_RC=$?
END_DESTROY=$(date +%s); DESTROY_RC=${DESTROY_RC:-0}

START_APPLY=$(date +%s)
{ "${TIME_BIN}" -v -o "${APPLY_TIME}" "$TF_BIN" apply -auto-approve 2>&1 \
  | ts_or_cat | tee "${APPLY_LOG}"; } || APPLY_RC=$?
END_APPLY=$(date +%s); APPLY_RC=${APPLY_RC:-0}

DESTROY_SECS=$(( END_DESTROY - START_DESTROY ))
APPLY_SECS=$(( END_APPLY - START_APPLY ))
{
  echo "=== Terraform Run Summary (${RUN_ID}) ==="
  echo "TF_BIN : ${TF_BIN}"
  echo "Destroy: exit=${DESTROY_RC}, duration=${DESTROY_SECS}s, log=${DESTROY_LOG}, time_detail=${DESTROY_TIME}"
  echo "Apply  : exit=${APPLY_RC}, duration=${APPLY_SECS}s, log=${APPLY_LOG}, time_detail=${APPLY_TIME}"
} | tee "${SUMMARY}"

if [[ ${DESTROY_RC} -ne 0 || ${APPLY_RC} -ne 0 ]]; then
  echo "One or more steps failed. See logs in ${LOG_DIR}"
  exit 1
fi
echo "Completed successfully. See ${SUMMARY}"

