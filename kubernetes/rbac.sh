# 给与 kubelet-bootstrap 用户进行 node-bootstrapper 的权限
kubectl create clusterrolebinding kubelet-bootstrap \
    --clusterrole=system:node-bootstrapper \
    --user=kubelet-bootstrap

kubectl create -f tls-bootstrapping-clusterrole.yaml

# 自动批准 system:bootstrappers 组用户 TLS bootstrapping 首次申请证书的 CSR 请求
kubectl create clusterrolebinding node-client-auto-approve-csr \
        --clusterrole=system:certificates.k8s.io:certificatesigningrequests:nodeclient \
        --group=system:bootstrappers

# 自动批准 system:nodes 组用户更新 kubelet 自身与 apiserver 通讯证书的 CSR 请求
kubectl create clusterrolebinding node-client-auto-renew-crt \
        --clusterrole=system:certificates.k8s.io:certificatesigningrequests:selfnodeclient \
        --group=system:nodes

# 自动批准 system:nodes 组用户更新 kubelet 10250 api 端口证书的 CSR 请求
kubectl create clusterrolebinding node-server-auto-renew-crt \
        --clusterrole=system:certificates.k8s.io:certificatesigningrequests:selfnodeserver \
        --group=system:nodes
