# 先创建 RBAC
kubectl apply -f \
https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/rbac.yaml

# 再创建 Calico Daemonset
kubectl create -f calico.yaml
