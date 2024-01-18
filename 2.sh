#!/bin/bash

# 修改SSH默认端口
# 你可以将2222替换为你希望的端口号
NEW_SSH_PORT=10022

# 备份原始的sshd_config文件
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 修改端口
sudo sed -i "s/#Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config

# 重启SSH服务
sudo systemctl restart ssh

# 安装Fail2Ban
sudo apt install -y fail2ban

# 切换到Fail2Ban配置目录
cd /etc/fail2ban

# 拷贝配置文件
sudo cp fail2ban.conf fail2ban.local
sudo cp jail.conf jail.local

# 删除现有的jail.local文件中的内容
sudo echo "" > jail.local

# 添加[DEFAULT]配置
sudo bash -c 'cat << EOF >> jail.local
#DEFAULT配置开始
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 1h
findtime = 1m
maxretry = 3
banaction = iptables-multiport
action = %(action_mwl)s
#DEFAULT配置结束

EOF'

# 添加[sshd]服务配置，确保使用新的端口号
sudo bash -c 'cat << EOF >> jail.local
#sshd服务配置开始
[sshd]
enabled = true
filter = sshd
port = $NEW_SSH_PORT
maxretry = 3
findtime = 60
bantime = -1
action = %(action_mwl)s
#sshd服务配置结束

EOF'

# 重启Fail2Ban服务以应用更改
sudo systemctl restart fail2ban
sleep 5
sudo fail2ban-client status sshd
