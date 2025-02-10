#!/bin/bash
set -eux  # 오류 발생 시 즉시 종료, 실행된 명령어 출력

# 1. Prometheus 다운로드 및 설치
cd /tmp
curl -LO "https://github.com/prometheus/prometheus/releases/download/v3.1.0/prometheus-3.1.0.linux-arm64.tar.gz"

# 2. /etc/prometheus 디렉토리 생성 및 압축 해제
mkdir -p /etc/prometheus
tar xvf prometheus-3.1.0.linux-arm64.tar.gz -C /etc/prometheus --strip-components=1

# 3. Prometheus 실행을 위한 사용자 생성
useradd --no-create-home --shell /bin/false prometheus
chown -R prometheus:prometheus /etc/prometheus

# 4. Prometheus 데이터 디렉토리 생성
mkdir -p /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

# 5. systemd 서비스 파일 설정
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
WorkingDirectory=/etc/prometheus
ExecStart=/etc/prometheus/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus

Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 6. systemd 서비스 적용 및 실행
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# 7. Node Exporter 다운로드 및 설치
cd /tmp
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-arm64.tar.gz"
tar xvf node_exporter-1.6.0.linux-arm64.tar.gz
# 바이너리를 /usr/local/bin/으로 이동
mv node_exporter-1.6.0.linux-arm64/node_exporter /usr/local/bin/

# 8. Node Exporter 실행을 위한 사용자 생성
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# 9. systemd 서비스 파일 설정 (Node Exporter)
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 10. systemd 서비스 적용 및 실행 (Node Exporter)
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# 11. Prometheus 설정 파일(prometheus.yml)에 Node Exporter 스크랩 설정 추가
# 이미 scrape_configs 섹션이 존재할 경우에는 원하는 위치에 추가하거나, 별도로 추가합니다.
cat <<EOT >> /etc/prometheus/prometheus.yml

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOT

# 12. Prometheus 서비스 재시작
systemctl restart prometheus