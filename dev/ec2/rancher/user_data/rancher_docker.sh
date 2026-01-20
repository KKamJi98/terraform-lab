#!/bin/bash
set -euo pipefail

# Docker 설치 (Amazon Linux 2023)
dnf update -y
dnf install -y docker
systemctl enable docker
systemctl start docker

# ec2-user를 docker 그룹에 추가
usermod -aG docker ec2-user

# Rancher 컨테이너 실행
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:v2.7.8
