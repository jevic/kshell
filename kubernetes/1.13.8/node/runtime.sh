#!/bin/bash

Start(){
systemctl start nginx-proxy
systemctl start kubelet
systemctl start kube-proxy
}

Stop(){
systemctl stop kubelet
systemctl stop kube-proxy
systemctl stop nginx-proxy
}

Enable(){
systemctl enable nginx-proxy
systemctl enable kubelet
systemctl enable kube-proxy
}


case $1 in
    start) Start ;;
    stop) Stop ;;
    en) Enable;;
    *)
    echo "start|stop|en"
    echo "启动|停止|开机自启动添加" 
esac
