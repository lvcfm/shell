#!/bin/bash

a=$(echo `yum list php* | grep fpm`)
b=${a%%-*}
c=$(echo ${b}"-fpm")
d=$(echo ${b}"-mysql")
e=$(echo ${b} ${c} ${d})
result=$(echo $`rpm -qa | grep php` | grep fpm)


if [[ "$result" = "" ]]
then

echo "--------------安装PHP--------------"
sleep 2s
yum install ${e} -y
sleep 2
systemctl start $c.service
echo "开启php服务"
systemctl enable $c.service
echo "添加PHP开机自启"

else

echo "本机已经安装php服务，请勿重复安装"
systemctl start $c.service
echo "开启php服务"
systemctl enable $c.service
echo "添加PHP开机自启"

fi
exit 0