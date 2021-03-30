#/bin/bash
#####echo "Create Signing Key and CSR"
openssl req -nodes -newkey rsa:2048 -keyout registry-auth.key -out registry-auth.csr -subj "/CN=rg.rmd5.ru"
#####echo "Self-Sign Certificate"
openssl x509 -in registry-auth.csr -out registry-auth.crt -req -signkey registry-auth.key -days 3650
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -days 1024 -out rootCA.pem
openssl genrsa -out registry.key 2048
openssl req -new -key registry.key -out registry.csr
###### Common Name
####Common Name (eg, YOUR name) []: rg.example.com
openssl x509 -req -in registry.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out registry.crt -days 3000