#!/bin/bash
set -e

# 소스 인스턴스의 InfluxDB 데이터 디렉토리 및 WAL 경로 (환경에 맞게 수정)
SOURCE_DATADIR="/var/lib/influxdb/data"
SOURCE_WALDIR="/var/lib/influxdb/wal"

# 대상 인스턴스의 IP 또는 호스트명 (예: 10.0.1.67)
TARGET_HOST="10.0.1.67"

echo "=== 데이터베이스 목록 추출 ==="
# SHOW DATABASES 명령어의 CSV 출력에서 헤더 제거, 따옴표 삭제 및 'databases,' 접두사 제거
DATABASES=$(influx -execute "SHOW DATABASES" -format csv | tail -n +2 | tr -d '"' | sed 's/^databases,//')

for DB in $DATABASES; do
  # 공백 제거
  DB=$(echo "$DB" | xargs)
  # 빈 문자열이나 시스템 데이터베이스(_internal)는 건너뜁니다.
  if [[ -z "$DB" || "$DB" == "_internal" ]]; then
      continue
  fi

  echo "=== '$DB' 데이터베이스 데이터 내보내기 ==="
  EXPORT_FILE="/tmp/${DB}_export.lp"
  CLEAN_FILE="/tmp/${DB}_export_clean.lp"

  # 해당 데이터베이스의 데이터를 라인 프로토콜 형식으로 내보냅니다.
  influx_inspect export -database "$DB" -datadir "$SOURCE_DATADIR" -waldir "$SOURCE_WALDIR" -lponly -out "$EXPORT_FILE"

  echo "=== '$DB'에서 DDL 명령문 제거 (순수 데이터만 추출) ==="
  grep -v "^CREATE DATABASE" "$EXPORT_FILE" > "$CLEAN_FILE"

  echo "=== 대상 인스턴스에서 '$DB' 데이터베이스 생성 ==="
  # 대상 인스턴스에 POST 방식으로 데이터베이스 생성 쿼리 전송
  curl -i -XPOST "http://${TARGET_HOST}:8086/query" --data-urlencode "q=CREATE DATABASE $DB" >/dev/null

  echo "=== '$DB' 데이터 대상 인스턴스로 전송 ==="
  curl -i -XPOST "http://${TARGET_HOST}:8086/write?db=${DB}&precision=ns" --data-binary @"$CLEAN_FILE"

  echo "=== '$DB' 마이그레이션 완료 ==="
done

echo "=== 모든 데이터베이스 마이그레이션 완료 ==="
