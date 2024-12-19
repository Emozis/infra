#!/bin/bash

# 시스템 업데이트
sudo yum update -y

# docker 설치 및 실행
sudo yum install -y docker
sudo service docker start

# docker 그룹 생성 및 ec2-user 추가
sudo groupadd docker
sudo usermod -aG docker ec2-user
newgrp docker

# docker 앱 실행
docker pull isakin/emogi-app:latest
docker run -d \
  --name emogi-app \
  -e ENV=prod \
  -v ~/.aws:/root/.aws \
  -p 80:8000 \
  --health-cmd='python -c "import urllib.request; urllib.request.urlopen(\"http://localhost:8000/health\")"' \
  --health-interval=10s \
  --health-timeout=5s \
  --health-retries=5 \
  --health-start-period=20s \
  isakin/emogi-app:latest

# docker 자동 시작 설정
sudo systemctl enable docker