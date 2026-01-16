#!/bin/bash
# query_influx.sh
# 이 스크립트는 InfluxDB의 test_data 데이터베이스에서 test_data measurement의 모든 데이터를 조회합니다.

set -euo pipefail

# 설정 변수
DATABASE="test_db"
MEASUREMENT="test_data"
QUERY="SELECT * FROM ${MEASUREMENT}"

echo "InfluxDB에서 데이터 조회: 데이터베이스 [${DATABASE}], 쿼리 [${QUERY}]"

# Influx CLI를 이용해 쿼리 실행 (대상 데이터베이스 지정)
influx -database "${DATABASE}" -execute "${QUERY}"
