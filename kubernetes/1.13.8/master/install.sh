#!/bin/bash
# 下载 hyperkube
function download_k8s(){
    if [ ! -f "hyperkube_v${KUBE_VERSION}" ]; then
        wget https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/hyperkube -O hyperkube_v${KUBE_VERSION}
        chmod +x hyperkube_v${KUBE_VERSION}
    fi
}

function install_k8s(){
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

function postinstall(){
    if [ ! -d "/var/log/kube-audit" ]; then
        mkdir /var/log/kube-audit
    fi
    
    if [ ! -d "/var/lib/kubelet" ]; then
        mkdir /var/lib/kubelet
    fi
    if [ ! -d "/usr/libexec" ]; then
        mkdir /usr/libexec
    fi
}

install_k8s
postinstall
