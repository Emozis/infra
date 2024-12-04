#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo yum install -y docker
sudo service docker start
sudo docker pull isakin/emogi-app:latest
sudo docker run -d -p 8000:8000 --name emogi-app isakin/emogi-app:latest