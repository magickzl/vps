#!/bin/bash  

# 切换到root用户  
sudo su -  

# 备份原始的sshd配置文件  
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak  

# 修改sshd配置文件  
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config  
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config  

# 重启SSH服务  
/etc/init.d/ssh restart  

echo "SSH configuration updated and service restarted."  