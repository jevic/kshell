#!/bin/bash
init() {
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disalbe/g' /etc/sysconfig/selinux

cat >> /etc/security/limits.conf <<EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc unlimited
* hard nproc unlimited
EOF

sed -ri '/^[^#]*swap/s@^@#@' /etc/fstab
swapoff -a

systemctl stop firewalld && systemctl disable firewalld


cat >> /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
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
net.netfilter.nf_conntrack_max=2310720
EOF

sysctl -p

yum install -y wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install -y epel-release
yum install -y conntrack ipvsadm ipset jq sysstat curl iptables libseccomp ntpdate telnet iproute git lrzsz
ntpdate cn.pool.ntp.org
}

kernel(){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-lt-devel kernel-lt -y
## 默认启动的顺序是从0开始，新内核是从头插入（目前位置在0，而4.4的是在1），所以需要选择0
grub2-set-default 0
}

ipvs(){
:> /etc/modules-load.d/ipvs.conf
module=(
ip_vs
ip_vs_lc
ip_vs_wlc
ip_vs_rr
ip_vs_wrr
ip_vs_lblc
ip_vs_lblcr
ip_vs_dh
ip_vs_sh
ip_vs_fo
ip_vs_nq
ip_vs_sed
ip_vs_ftp
nf_conntrack
  )
for kernel_module in ${module[@]};do
    /sbin/modinfo -F filename $kernel_module |& grep -qv ERROR && echo $kernel_module >> /etc/modules-load.d/ipvs.conf || :
done
systemctl enable --now systemd-modules-load.service
}

docker(){
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl stop docker
}

registry_init(){
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://dlvqhrac.mirror.aliyuncs.com"],
  "insecure-registries": ["registry-k8s.novalocal"]
}
EOF
}

init_history(){
cat >>/etc/profile <<EOF
## 设置history格式
export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] [`who am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`] "
## 实时记录用户在shell中执行的每一条命令
export PROMPT_COMMAND='\
if [ -z "\$OLD_PWD" ];then
    export OLD_PWD=\$PWD;
    fi;
    if [ ! -z "$\LAST_CMD" ] && [ "\$(history 1)" != "\$LAST_CMD" ]; then
        logger -t `whoami`_shell_cmd "[\$OLD_PWD]\$(history 1)";
        fi ;
        export LAST_CMD="\$(history 1)";
        export OLD_PWD=\$PWD;'
EOF
source /etc/profile
}

## 初始化系统
init
## 内核升级
kernel
## ipvs 内核模块加载
ipvs
## 安装docker
docker
## 配置加速器和私有仓库
registry_init
## 配置历史命令记录
init_history
