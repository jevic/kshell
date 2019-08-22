docker run -d --restart=unless-stopped \
-n rancher \
-p 80:80 -p 443:443 \
-v /var/lib/rancher:/var/lib/rancher/ \
-v /var/log/rancher/auditlog:/var/log/auditlog \
-e AUDIT_LEVEL=3 \
rancher/rancher:stable
