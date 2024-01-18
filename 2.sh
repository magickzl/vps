#!/bin/bash
sudo apt install -y fail2ban

# 切换到 fail2ban 配置目录
cd /etc/fail2ban

# 拷贝配置文件
sudo cp fail2ban.conf fail2ban.local
sudo cp jail.conf jail.local

# 删除现有的 jail.local 文件中的内容
sudo echo "" > jail.local

# 添加 [DEFAULT] 配置
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

# 添加 [sshd] 服务配置
sudo bash -c 'cat << EOF >> jail.local
#sshd服务配置开始
[sshd]
enabled = true
filter = sshd
port = 10022
maxretry = 3
findtime = 60
bantime = -1
action = %(action_mwl)s
#sshd服务配置结束

EOF'

# 重启 fail2ban 服务以应用更改
sudo systemctl restart fail2ban

sudo fail2ban-client status sshd
