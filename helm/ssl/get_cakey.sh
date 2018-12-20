openssl genrsa -out ./ca.key.pem 4096

openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca
