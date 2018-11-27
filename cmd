#!/bin/bash
## 批量执行命令
iplist="node220 node221"

for i in $iplist
do
   echo -e "\033[32mssh $i \"$*\"\033[0m"
   ssh $i "$*"
done
