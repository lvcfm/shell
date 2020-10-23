#!/bin/bash

echo "--------------安装MySql--------------"

function readpwd() {
    read -p "请输入MySql密码:" pwd
    echo $pwd
    read -p "请重复输入MySql密码:" repwd
    echo $repwd
}

function settingpwd() {
    if [ $pwd = $repwd ]
    then
        echo "密码设置成功，请妥善保管！密码是：$repwd"
    else
        echo "密码不一致"
        readpwd
        settingpwd
    fi  
}

result_1=$(echo $`rpm -qa | grep mysql` | grep server)

if [[ "$result_1" = "" ]]
then
    mkdir -p /data/tmp
    cd /data/tmp
    wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
    sudo rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
    yum install  -y  mysql-community-server
    sleep 1s
    result_2=$(echo $`rpm -qa | grep mysql` | grep server)
    if [[ "$result_2" = "" ]]
    then
        echo "安装失败"
    else
        echo "--------------设置MySql密码--------------"
        service mysqld start
        sed -i '$avalidate_password = off' /etc/my.cnf
        readpwd
        settingpwd
        echo "-----Login_MySQL-----"
        echo "获取MySql的默认密码"
        oldkey=$(echo `grep 'temporary password' /var/log/mysqld.log`)
        oldpwd=`echo ${oldkey#*root@localhost: }`
        echo $oldpwd
        echo "看见Enter password: 后输入默认密码 <回车>后登陆"
        mysql -h 127.0.0.1 -uroot -p -P3306 << EOF
        set global validate_password_policy=0;
        set global validate_password_length=1;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${repwd}';
        \q
EOF

        echo "尝试使用新密码登陆"
        echo "看见Enter password: 后输入新密码${repwd} <回车>后登陆"
        mysql -h 127.0.0.1 -uroot -p -P3306 << EOF
        show databases;
        \q
EOF
        echo "看见database等即表示使用新密码登陆成功"
    fi

else
    echo "----已安装MySQL，安装停止----"
fi
