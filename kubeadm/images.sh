#!/bin/bash
## 使用开源社区镜像仓库
docker pull gcr.akscn.io/google_containers/kube-proxy:v1.13.1
docker pull gcr.akscn.io/google_containers/kube-scheduler:v1.13.1
docker pull gcr.akscn.io/google_containers/kube-controller-manager:v1.13.1
docker pull gcr.akscn.io/google_containers/kube-apiserver:v1.13.1
docker pull gcr.akscn.io/google_containers/coredns:1.2.6
docker pull gcr.akscn.io/google_containers/etcd:3.2.24
docker pull gcr.akscn.io/google_containers/pause:3.1
docker pull quay.io/coreos/flannel:v0.10.0-amd64

## tag
docker tag gcr.akscn.io/google_containers/kube-proxy:v1.13.1 k8s.gcr.io/kube-proxy:v1.13.1
docker tag gcr.akscn.io/google_containers/kube-scheduler:v1.13.1 k8s.gcr.io/kube-scheduler:v1.13.1
docker tag gcr.akscn.io/google_containers/kube-controller-manager:v1.13.1 k8s.gcr.io/kube-controller-manager:v1.13.1
docker tag gcr.akscn.io/google_containers/kube-apiserver:v1.13.1 k8s.gcr.io/kube-apiserver:v1.13.1
docker tag gcr.akscn.io/google_containers/coredns:1.2.6 k8s.gcr.io/coredns:1.2.6
docker tag gcr.akscn.io/google_containers/etcd:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag gcr.akscn.io/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
