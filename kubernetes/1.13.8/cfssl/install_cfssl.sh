#!/bin/bash

Download(){
#download cfssl
curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
#download cfssljson
curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

chmod +x /usr/local/bin/cfssl
chmod +x /usr/local/bin/cfssljson
}

init(){
	mv cfssl_linux-amd64 /usr/local/bin/cfssl
	mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
	chmod +x /usr/local/bin/cfssl
	chmod +x /usr/local/bin/cfssljson
}

case $1 in
   down)
   Download ;;
   init)
   init ;;
   *)
   echo "down | init"
esac
