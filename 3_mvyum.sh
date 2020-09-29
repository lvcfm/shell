#!/bin/bash

echo "----------更换默认yum为网易yum----------"
sleep 1s
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
mv /data/ftp/pub/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
yum clean all
echo "需要时间，请耐心等待..."
sleep 3s
yum makecache
result=$(echo $`cat /etc/yum.conf | grep exclude=kernel*` | grep exclude=kernel)
if [[ "$result" = "" ]]
then
    sed -i '$aexclude=kernel*' /etc/yum.conf
    sed -i '$aexclude=centos-release*' /etc/yum.conf
else
    echo ""
fi
sleep 1s
yum --exclude=kernel* update -y
exit 0