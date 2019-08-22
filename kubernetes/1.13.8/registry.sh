#!/bin/bash
## 私有仓库配置
Registry="registry-k8s.jevic.com"

sed -i "s/containerd.sock.*/& --insecure-registry=$Registry/g" /lib/systemd/system/docker.service
systemctl daemon-reload
