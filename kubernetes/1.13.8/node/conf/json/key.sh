cfssl gencert --initca=true k8s-root-ca-csr.json | cfssljson --bare k8s-root-ca

for targetName in kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet-api-admin admin; do
    cfssl gencert --ca k8s-root-ca.pem --ca-key k8s-root-ca-key.pem --config k8s-gencert.json --profile kubernetes $targetName-csr.json | cfssljson --bare $targetName
done
