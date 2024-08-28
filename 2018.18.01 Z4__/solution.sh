#!/bin/bash
mkdir keys && mv *.key keys/

#Svi kljucevi su RSA private. Izdvojimo javne kljuceve.
for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.key -inform pem -pubout > keys/public$i.pem;
done;

#Pronadjimo match.
for i in {1..100}; do
    if [[ "$(diff client-public.pem keys/public$i.pem | awk 'NR==1')" == "" ]];
    then mv keys/kljuc$i.key . && echo "MATCH: kljuc$i.key";
    fi;
done;
rm keys/public* 2>/dev/null

#Dobijamo "MATCH: kljuc52.key". Napravimp .p12 datoteku.
openssl pkcs12 -export -out client.p12 -inkey kljuc52.key -in client.pem -certfile ca.pem -passout pass:sigurnost
