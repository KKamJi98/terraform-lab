#!/bin/bash
set -eux

# 패키지 인덱스 갱신 및 Docker 설치
apt-get update
apt-get install -y docker.io

# AWS CLI 설치
snap install aws-cli --classic

# Docker 서비스 활성화
systemctl enable docker
systemctl start docker
EOF