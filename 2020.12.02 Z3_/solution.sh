#!/bin/bash

mkdir keys
mv *.key keys

#Dekodujemo kljuceve iz base64
for i in {1..100}; do
    openssl enc -d -base64 -in keys/kljuc$i.key -out keys/kljuc$i.der 
    rm keys/kljuc$i.key
done

#Svi kljucevi su u DER formatu, konvertujemo u PEM. *ovaj korak nije neophodan
for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.der -out keys/kljuc$i.pem -inform der -outform pem
    rm keys/kljuc$i.der
done

#Izdvojimo klijentski sertifikat iz cert.p12 datoteke
openssl pkcs12 -in cert.p12 -nokeys -clcerts -out client.pem -passin pass:sigurnost -legacy

#Izdvojimo javni kljuc iz client.pem
openssl x509 -in client.pem -pubkey -noout > public.pem

#Izdvojimo javne kljuceve iz 100 privatnih RSA kljuceva
for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.pem -pubout -out keys/public$i.pem
done

for i in {1..100}; do
    DIFF=$(diff keys/public$i.pem public.pem | awk 'NR==1')
    if [ "$DIFF" == "" ];
    then
        echo "MATCH: kljuc$i.key"
        break 
    fi
done

#66.key
