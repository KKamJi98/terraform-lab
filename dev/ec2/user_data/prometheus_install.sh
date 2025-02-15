#!/bin/bash
set -eux  # 오류 발생 시 즉시 종료, 실행된 명령어 출력

# -----------------------------
# 1. Prometheus 다운로드 및 설치
# -----------------------------
cd /tmp
curl -LO "https://github.com/prometheus/prometheus/releases/download/v3.1.0/prometheus-3.1.0.linux-arm64.tar.gz"

# /etc/prometheus 디렉토리 생성 및 압축 해제
mkdir -p /etc/prometheus
tar xvf prometheus-3.1.0.linux-arm64.tar.gz -C /etc/prometheus --strip-components=1

# Prometheus 실행을 위한 사용자 생성 및 권한 설정
useradd --no-create-home --shell /bin/false prometheus
chown -R prometheus:prometheus /etc/prometheus

# Prometheus 데이터 디렉토리 생성
mkdir -p /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

# -----------------------------
# 2. Prometheus systemd 서비스 설정
# -----------------------------
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

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# -----------------------------
# 3. Node Exporter 다운로드 및 설치
# -----------------------------
cd /tmp
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-arm64.tar.gz"
tar xvf node_exporter-1.6.0.linux-arm64.tar.gz
mv node_exporter-1.6.0.linux-arm64/node_exporter /usr/local/bin/

# Node Exporter 실행을 위한 사용자 생성 및 권한 설정
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# -----------------------------
# 4. Node Exporter systemd 서비스 설정
# -----------------------------
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

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# -----------------------------
# 5. Prometheus 설정에 Node Exporter 스크랩 설정 추가
# -----------------------------
cat <<EOT >> /etc/prometheus/prometheus.yml

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
  
  - job_name: 'python_app_server'
    static_configs:
      - targets: ['localhost:18081']
EOT

# -----------------------------
# 6. Python 및 Prometheus Client 설치
# -----------------------------
apt update
apt install python3-pip -y
pip3 install --break-system-packages prometheus_client

# -----------------------------
# 7. Python 애플리케이션 서버 스크립트 생성
# -----------------------------
cat <<'EOF' > /opt/app_server.py
import http.server
from prometheus_client import start_http_server, Counter

REQUEST_COUNT = Counter('app_requests_count', 'total app http requestcount')

APP_PORT = 18080
METRICS_PORT = 18081

class HandleRequests(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        REQUEST_COUNT.inc()
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b'<h1>Counter</h1>')

if __name__ == '__main__':
    # metrics 서버를 모든 인터페이스에 바인딩
    start_http_server(METRICS_PORT, addr='0.0.0.0')
    print(f'Metrics server started on 0.0.0.0:{METRICS_PORT}')
    
    # 애플리케이션 서버도 모든 인터페이스에 바인딩 (필요하다면)
    server = http.server.HTTPServer(('0.0.0.0', APP_PORT), HandleRequests)
    print(f'Application server started on 0.0.0.0:{APP_PORT}')
    server.serve_forever()
EOF

# -----------------------------
# 8. Python 애플리케이션 서버를 위한 systemd 서비스 설정 및 prometheus 재시작
# -----------------------------
cat <<EOF > /etc/systemd/system/app_server.service
[Unit]
Description=Python Prometheus Client Application Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/app_server.py
Restart=always
User=root
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=app_server

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable app_server
systemctl start app_server
systemctl restart prometheus
