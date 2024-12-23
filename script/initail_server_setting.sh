#!/bin/bash

# 시스템 업데이트
sudo yum update -y


# Nginx 설치
sudo yum install -y nginx

# docker 설치 및 실행
sudo yum install -y docker
sudo service docker start

# docker 그룹 생성 및 ec2-user 추가
sudo groupadd docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker ssm-user
newgrp docker

# docker 자동 시작 설정
sudo systemctl enable docker

# Nginx 설정 파일 생성
sudo cat > /etc/nginx/conf.d/app.conf <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Nginx 시작 및 자동 시작 설정
sudo systemctl start nginx
sudo systemctl enable nginx

# docker 앱 실행
docker pull isakin/emogi-app:latest
docker run -d \
  --name emogi-app \
  -e ENV=prod \
  -v ~/.aws:/root/.aws \
  -p 8000:8000 \
  --health-cmd='python -c "import urllib.request; urllib.request.urlopen(\"http://localhost:8000/health\")"' \
  --health-interval=10s \
  --health-timeout=5s \
  --health-retries=5 \
  --health-start-period=20s \
  isakin/emogi-app:latest