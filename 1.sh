#!/bin/bash

# 安装 Docker
wget -qO- get.docker.com | bash

# 下载并安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 创建目录并进入目录
mkdir -p /root/data/docker_data/npm
cd /root/data/docker_data/npm

# 创建 docker-compose.yaml 文件
echo "version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'  
      - '81:81'  
      - '443:443' 
    volumes:
      - ./data:/data 
      - ./letsencrypt:/etc/letsencrypt" > docker-compose.yaml

# 回到目录并启动 Docker Compose 服务
cd /root/data/docker_data/npm
docker-compose up -d
