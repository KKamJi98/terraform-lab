#!/bin/bash

# 한국 시간(UTC+9)으로 날짜를 계산: 
hour=$(TZ="Asia/Seoul" date +"%H")
minute=$(TZ="Asia/Seoul" date +"%M")

# 예: 02시 + 05분 = 7
sum=$((10#$hour + 10#$minute))

# (1) 로컬 influx (예: CentOS 자신의 Influx)
curl -i -XPOST "http://localhost:8086/write?db=test_db" \
  --data-binary "test_data,location=serverroom value=${sum}"

# (2) 원격 influx (예: Ubuntu Private IP가 10.0.1.244라 가정)
curl -i -XPOST "http://10.0.1.244:8086/write?db=test_db" \
  --data-binary "test_data,location=serverroom value=${sum}"