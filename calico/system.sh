K8S_MASTER_IP="192.168.2.219"
HOSTNAME=`cat /etc/hostname`
ETCD_ENDPOINTS="https://192.168.2.219:2379,https://192.168.2.220:2379,https://192.168.2.221:2379"

cat > /lib/systemd/system/calico-node.service <<EOF
[Unit]
Description=calico node
After=docker.service
Requires=docker.service

[Service]
User=root
Environment=ETCD_ENDPOINTS=${ETCD_ENDPOINTS}
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run   --net=host --privileged --name=calico-node \\
                                -e ETCD_ENDPOINTS=${ETCD_ENDPOINTS} \\
                                -e ETCD_CA_CERT_FILE=/etc/etcd/ssl/etcd-root-ca.pem \\
                                -e ETCD_CERT_FILE=/etc/etcd/ssl/etcd.pem \\
                                -e ETCD_KEY_FILE=/etc/etcd/ssl/etcd-key.pem \\
                                -e NODENAME=${HOSTNAME} \\
                                -e IP= \\
                                -e IP_AUTODETECTION_METHOD=can-reach=${K8S_MASTER_IP} \\
                                -e AS=64512 \\
                                -e CLUSTER_TYPE=k8s,bgp \\
                                -e CALICO_IPV4POOL_CIDR=10.20.0.0/16 \\
                                -e CALICO_IPV4POOL_IPIP=always \\
                                -e CALICO_LIBNETWORK_ENABLED=true \\
                                -e CALICO_NETWORKING_BACKEND=bird \\
                                -e CALICO_DISABLE_FILE_LOGGING=true \\
                                -e FELIX_IPV6SUPPORT=false \\
                                -e FELIX_DEFAULTENDPOINTTOHOSTACTION=ACCEPT \\
                                -e FELIX_LOGSEVERITYSCREEN=info \\
                                -e FELIX_IPINIPMTU=1440 \\
                                -e FELIX_HEALTHENABLED=true \\
                                -e CALICO_K8S_NODE_REF=${HOSTNAME} \\
                                -v /etc/calico/ssl:/etc/etcd/ssl \\
                                -v /lib/modules:/lib/modules \\
                                -v /var/lib/calico:/var/lib/calico \\
                                -v /var/run/calico:/var/run/calico \\
                                k8s.yfcloud.com/calico/node:v3.1.0
ExecStop=/usr/bin/docker rm -f calico-node
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
