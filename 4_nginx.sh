#!/bin/bash

result_1=$(echo $`rpm -qa | grep nginx-1` | grep nginx)
if [[ "$result_1" = "" ]]
then

echo "------ Start installing Nginx ------"
sleep 1s
yum install -y nginx
clear
sleep 1s
nginx
systemctl enable nginx.service
echo "安装完成Nginx并设置为开机自启！"
echo "copy证书..."
cp /data/ftp/pub/1_www.yutan.me_bundle.crt /etc/nginx
cp /data/ftp/pub/2_www.yutan.me.key /etc/nginx
echo "新建/data/nginx/html文件夹"
mkdir -p /data/nginx/html
echo "移动网站源文件至html文件夹下"
mv /data/ftp/pub/www/* /data/nginx/html
echo "修改nginx配置文件"
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
mv /data/ftp/pub/nginx.conf /etc/nginx/nginx.conf
pkill -9 nginx
nginx

else

echo "本机已经安装nginx，请勿再次安装"

fi