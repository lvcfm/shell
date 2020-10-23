#!/bin/bash

result=`systemctl status firewalld | grep running`
if [[ "$result" != "" ]]
then

  i=0
  read -p $'输入需要开启的端口号并用空格隔开（例如：80 443 1000-1010）\x0a请输入：' val

  #获取输入的数值并将其转化为数组
  for x in $val
  do
    arrPorts[$i]=$x
    ((i++))
  done

  for((a=0;a<$i;a++))
  do
    echo "开启${arrPorts[$a]}端口"
    firewall-cmd --zone=public --add-port=${arrPorts[$a]}/tcp --permanent
  done

  firewall-cmd --reload
  clear
  echo "此系统一共开启以下端口："
  firewall-cmd --list-ports

else
  clear
  echo "抱歉，此系统并没有开启firewalld防火墙，即将退出脚本"
  sleep 1s
fi
