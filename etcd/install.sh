#!/bin/bash

set -e

ETCD_VERSION="3.2.18"

preinstall(){
    getent group etcd >/dev/null || groupadd -r etcd
    getent passwd etcd >/dev/null || useradd -r -g etcd -d /var/lib/etcd -s /sbin/nologin -c "etcd user" etcd
}

install(){
    echo -e "\033[32mINFO: Copy etcd...\033[0m"
    tar -zxvf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
    cp etcd-v${ETCD_VERSION}-linux-amd64/etcd* /usr/local/bin
    rm -rf etcd-v${ETCD_VERSION}-linux-amd64
    echo -e "\033[32mINFO: Copy etcd config...\033[0m"
    cp -r conf /etc/etcd
    chown -R etcd:etcd /etc/etcd
    chmod -R 755 /etc/etcd/ssl
    echo -e "\033[32mINFO: Copy etcd systemd config...\033[0m"
    cp etcd.service /lib/systemd/system
    systemctl daemon-reload
}

postinstall(){
    if [ ! -d "/var/lib/etcd" ]; then
        mkdir /var/lib/etcd
        chown -R etcd:etcd /var/lib/etcd
    fi
}

preinstall
install
postinstall
