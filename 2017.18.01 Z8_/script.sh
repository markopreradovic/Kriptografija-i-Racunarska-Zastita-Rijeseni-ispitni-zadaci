#!/bin/bash

keys="kljuc*"

for k in $keys
do
    openssl rsa -in $k -out pem/$k -inform DER -outform PEM
done

openssl pkcs12 -in cert.p12 -out priv.key -nocerts -passin pass:sigurnost -passout pass:sigurnost -legacy
openssl rsa -in priv.key -out priv.pem -inform PEM -outform PEM -passin pass:sigurnost

for i in {1..100}
do
    if [ "$(diff pem/kljuc$i.key priv1.key)" == "" ]
    then
        echo -e "Kljuc je: $i" 
        break
    fi
done


