#!/bin/bash

openssl rsa -in kljuc.key -pubin -out kljuc.pem.key -inform DER -outform PEM

mkdir p12
for i in {1..100}
do
    keytool -importkeystore -srckeystore store$i.jks -destkeystore p12/stores$i.p12 -srcstoretype jks -deststoretype pkcs12 -srcstorepass sigurnost -deststorepass sigurnost
done

for i in {1..100}
do 
   openssl pkcs12 -in p12/stores$i.p12 -nocerts -out keys/kljuc$i.key -passin pass:sigurnost -passout pass:sigurnost
done

keys="keys/kljuc*"


for i in {1..100}
do
    openssl rsa -in keys/kljuc$i.key -inform PEM -outform PEM -out keys/pub/kljuc$i.key -pubout -passin pass:sigurnost
    
done

for i in {1..100}
do
    if [ "$(diff kljuc.pem.key keys/pub/kljuc$i.key)" == "" ]
    then
        echo -e "Kljuc je: $i" 
        break
    fi
done
