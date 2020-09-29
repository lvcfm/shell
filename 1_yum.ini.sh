#!/bin/bash

cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
echo "------避免为禁用yum插件导致安装出错，禁用yum插件------"
result_1=$(echo $`grep "plugins" /etc/yum.conf` | grep 0)
result_2=$(echo $`grep "enabled" /etc/yum/pluginconf.d/fastestmirror.conf` | grep 0)
if [[ "$result_1" = "" ]]
then
    echo "未禁用yum中的插件"
    echo "关闭插件中..."
    sed -i "s/plugins=1/plugins=0/g" /etc/yum.conf
    echo "完成"
else
    echo "插件未开启！"
fi
if [[ "$result_2" = "" ]]
then
    echo "未禁用yum中的加速插件fastestmirror"
    echo "关闭插件中..."
    sed -i "s/enabled=1/enabled=0/g" /etc/yum/pluginconf.d/fastestmirror.conf
    echo "完成"
else
    echo "插件未开启！"
fi

echo "------EXIT------"
exit
