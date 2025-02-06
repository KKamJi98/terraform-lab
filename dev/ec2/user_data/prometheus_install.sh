#!/bin/bash
set -eux

PROMETHEUS_VERSION="3.1.0"
PROMETHEUS_TAR="prometheus-${PROMETHEUS_VERSION}.linux-arm64.tar.gz"
PROMETHEUS_DIR="prometheus-${PROMETHEUS_VERSION}.linux-arm64"

apt-get update -y
apt-get install -y wget tar

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_TAR}
tar xvf ${PROMETHEUS_TAR}

cp ${PROMETHEUS_DIR}/prometheus /usr/local/bin/
cp ${PROMETHEUS_DIR}/promtool /usr/local/bin/
mkdir -p /etc/prometheus
cp -r ${PROMETHEUS_DIR}/consoles /etc/prometheus/
cp -r ${PROMETHEUS_DIR}/console_libraries /etc/prometheus/
cp ${PROMETHEUS_DIR}/prometheus.yml /etc/prometheus/prometheus.yml

useradd --no-create-home --shell /usr/sbin/nologin prometheus
chown -R prometheus:prometheus /etc/prometheus

mkdir -p /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
