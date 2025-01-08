#!/bin/bash

# 设置 PS1 环境变量，更改用户名和主机名颜色
export PS1="\[\e[1m\e[38;5;158m\]\u\[\e[m\]@\[\e[1m\e[38;5;111m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\$ "

# 提示用户输入新的主机名
read -p "请输入新的主机名: " new_hostname

# 检查用户是否输入了主机名
if [ -z "$new_hostname" ]; then
    echo "未输入主机名，脚本已退出。"
    exit 1
fi

# 获取当前主机名
current_hostname=$(hostname)

# 修改主机名 (临时)
sudo hostname "$new_hostname"

# 修改 /etc/hosts 文件
if grep -q "$current_hostname" /etc/hosts; then
    sudo sed -i "s/$current_hostname/$new_hostname/g" /etc/hosts
else
    echo "警告: 未在 /etc/hosts 中找到当前主机名，可能需要手动添加。"
    echo "请在 /etc/hosts 中添加一行，格式为：127.0.1.1 $new_hostname"
fi

# 打印提示信息
echo "主机名已修改为: $new_hostname"
echo "已修改 /etc/hosts 文件。"

# 为了使新的主机名立即生效，可以尝试以下命令，但并非所有系统都适用
# (通常需要重新打开终端或重新登录才能完全生效)
# hostnamectl set-hostname "$new_hostname"
# 或者
# exec bash  # 重新启动bash

exit 0
