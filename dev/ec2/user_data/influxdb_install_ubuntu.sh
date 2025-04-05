#!/bin/bash
# 시스템 업데이트 및 필수 패키지 설치
sudo apt update -y
sudo apt install -y wget

# influxdb 사용자가 없는 경우 미리 생성 (이미 있다면 건너뜁니다)
if ! id -u influxdb >/dev/null 2>&1; then
    sudo useradd -r -m -s /usr/sbin/nologin influxdb
fi

# InfluxDB 1.11.8 .deb 파일 다운로드
wget https://download.influxdata.com/influxdb/releases/influxdb-1.11.8-amd64.deb

# .deb 파일 설치
sudo dpkg -i influxdb-1.11.8-amd64.deb

# InfluxDB 서비스 활성화 및 시작
sudo systemctl enable influxdb
sudo systemctl start influxdb
