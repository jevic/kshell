export KUBE_APISERVER="https://192.168.13.100:6443"

kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/k8s-root-ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER}

kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/ssl/admin.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/admin-key.pem

kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin

kubectl config use-context kubernetes
