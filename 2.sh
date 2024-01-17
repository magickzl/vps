#!/bin/bash

# 安装 fail2ban
sudo apt install -y fail2ban

# 切换到 fail2ban 配置目录
cd /etc/fail2ban

# 拷贝配置文件
sudo cp fail2ban.conf fail2ban.local
sudo cp jail.conf jail.local

# 编辑 jail.local 文件
# 使用 sed 命令来添加或修改配置

# 修改 DEFAULT 部分
sudo sed -i "/\[DEFAULT\]/a ignoreip = 127.0.0.1/8 ::1" jail.local
sudo sed -i "/\[DEFAULT\]/a bantime = 1h" jail.local
sudo sed -i "/\[DEFAULT\]/a findtime = 1m" jail.local
sudo sed -i "/\[DEFAULT\]/a maxretry = 3" jail.local
sudo sed -i "/\[DEFAULT\]/a banaction = firewallcmd-ipset" jail.local
sudo sed -i "/\[DEFAULT\]/a action = %\(action_mwl\)s" jail.local

# 添加 sshd 服务配置
sudo bash -c 'cat << EOF >> jail.local
# sshd 服务配置开始
[sshd]
enabled = true
filter = sshd
port = 22
maxretry = 3
findtime = 60
bantime = -1
action = %\(action_mwl\)s
# sshd 服务配置结束
EOF'

# 重启 fail2ban 服务以应用更改
sudo systemctl restart fail2ban
