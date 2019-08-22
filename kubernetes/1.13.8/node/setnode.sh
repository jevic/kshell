#!/bin/bash
### 修改节点信息
## hostname
NODE="k8s-node02"
## IP
IP="192.168.1.234"

## kubelet
sed -i "s/IP/$IP/g" /etc/kubernetes/kubelet
sed -i "s/NODE/$NODE/g" /etc/kubernetes/kubelet
## proxy
sed -i "s/NODE/$NODE/g" /etc/kubernetes/proxy
