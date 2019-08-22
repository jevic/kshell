#!/bin/bash
## 初始化 node 节点
# 下载 hyperkube
download_k8s(){
    if [ ! -f "hyperkube_v${KUBE_VERSION}" ]; then
        wget https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/hyperkube -O hyperkube_v${KUBE_VERSION}
        chmod +x hyperkube_v${KUBE_VERSION}
    fi
}

install_k8s(){
    echo -e "\033[32mINFO: Copy hyperkube...\033[0m"
    cp hyperkube_v${KUBE_VERSION} /usr/bin/hyperkube

    echo -e "\033[32mINFO: Create symbolic link...\033[0m"
    (cd /usr/bin && hyperkube --make-symlinks)

    echo -e "\033[32mINFO: Copy kubernetes config...\033[0m"
    cp -r conf /etc/kubernetes
    
    echo -e "\033[32mINFO: Copy kubernetes systemd config...\033[0m"
    cp systemd/*.service /lib/systemd/system
    
    systemctl daemon-reload
}

nginx_proxy(){
## master节点如有更改请手动更新配置
   echo -e "\033[32mINFO: Copy kubernetes nginx-proxy HA config...\033[0m"
   cp -a nginx /etc/
}

postinstall(){
    if [ ! -d "/var/log/kube-audit" ]; then
        mkdir /var/log/kube-audit
    fi
    
    if [ ! -d "/var/lib/kubelet" ]; then
        mkdir /var/lib/kubelet
    fi
    if [ ! -d "/usr/libexec" ]; then
        mkdir /usr/libexec
    fi
    ## coredns support
    if [ ! -d "/var/lib/resolve" ];then
	mkdir -p /var/lib/resolve/ 
        ln -s /etc/resolv.conf /var/lib/resolve/resolv.conf
    fi
}

install_k8s
postinstall
nginx_proxy
