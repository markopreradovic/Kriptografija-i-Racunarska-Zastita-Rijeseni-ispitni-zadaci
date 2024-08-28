#!/bin/bash

openssl pkcs12 -in cert.p12 -nokeys -clcerts -out client.crt -legacy -passin pass:sigurnost
openssl x509 -in client.crt -pubkey -noout > client-public.key

for i in {1..100}
do
    openssl rsa -in kljuc$i.key -inform DER -outform PEM -out kljuc$i.pem
    openssl rsa -in kljuc$i.pem -pubout -out public.key
    if [[ "$(cat client-public.key)" == "$(cat public.key)" ]]
    then 
        echo "Kljuc je kljuc$i.key"
        break
    fi
done
