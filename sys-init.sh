#!/bin/bash
set -e


init(){
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum makecache fast

yum install -y epel-release
yum install -y conntrack ipvsadm ipset jq sysstat curl iptables libseccomp ntpdate

systemctl stop firewalld && systemctl disable firewalld
sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
ntpdate cn.pool.ntp.org
}

set_kernel(){
echo "net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.ipv4.tcp_tw_recycle=0
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720" >> /etc/sysctl.conf
}


install_docker(){
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce-18.06.0.ce
}

init
set_kernel
install_docker
