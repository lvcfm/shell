#!/bin/bash

echo "------ Start installing VSFTPD ------"
sleep 1s
yum install vsftpd -y
clear
sleep 1s
service vsftpd start
sleep 1s
result=$(echo $`netstat -nltp | grep 21` | grep vsftpd)

if [[ "$result" != "" ]]
then
    echo "安装完成，正在启动vsftpd并配置FTP权限"
    echo "开机自启！"
    systemctl enable vsftpd.service
    sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" /etc/vsftpd/vsftpd.conf
    echo "禁止匿名访问和切换根目录"
    sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/g" /etc/vsftpd/vsftpd.conf
    echo "修改完成！"
    echo "正在重启FTP服务"
    service vsftpd restart
    echo "创建FTP用户ftpftp"
    useradd ftpftp
    echo "LVCFMftpPWD" | passwd ftpftp --stdin
    echo "限制用户 ftpftp 只能通过 FTP 访问服务器，而不能直接登录服务器："
    usermod -s /sbin/nologin ftpftp
    echo "为用户 ftpftp 创建主目录"
    mkdir -p /data/ftp/pub
    echo "Welcome to use FTP service." > /data/ftp/welcome.txt
    chmod a-w /data/ftp && chmod 777 -R /data/ftp/pub
    usermod -d /data/ftp ftpftp
    echo "安装配置完成，账号ftpftp密LVCFMftpPWD，请妥善保管"
    sed -i '/shell/ s/auth/#auth/' /etc/pam.d/vsftpd
    echo "防止使用账户密码连接不上ftp服务器！"
    service vsftpd restart
    echo "**********************************************"
else
    echo "安装失败！退出脚本"
    echo "----------------"
    sleep 1s
fi
