#!/bin/bash
mkdir keys && mv *.key keys/

#Izdvojimo privatni RSA kljuc iz pkcs12 datoteke
openssl pkcs12 -in cert.p12 -nocerts -out private.key -passin pass:sigurnost -passout pass:sigurnost

#Uklonimo lozinku sa kljuca 
openssl rsa -in private.key -inform pem -out private.pem -outform pem -passin pass:sigurnost && rm private.key

#Izbacimo CA sertifikat iz p12 datoteke i izdvojimo njegov public key
openssl pkcs12 -in cert.p12 -nokeys -cacerts -out prvi-zahtjev.pem -passin pass:sigurnost
openssl x509  -in prvi-zahtjev.pem -inform pem -pubkey -noout > prvizahtjev-pubkey.pem

#Kljucevi koji su dati zadatkom izgledaju kao da su svi u der formatu. Konvertujmo ih.
for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.key -out keys/kljuc$i.pem -inform DER -outform PEM && rm keys/kljuc$i.key;
done; 2>/dev/null

#Svi dobijeni kljucevi su private. Prvo poredimo sa private.pem kljucem.
for i in {1..100}; do
    if [[ "$(diff keys/kljuc$i.pem private.pem | awk 'NR==1')" == "" ]]
    then
        echo "MATCH: kljuc$i.key with private.pem (cert Prvi zahtjev key)";
        break;
    fi;
done 2>/dev/null;
#Dobijamo podudaranje: "MATCH: kljuc50.key with private.pem (cert Klijent74 key)"








#Da bi smo dalje poredili kljuceve sa klijent74-pubkey.pem moramo izdvojiti javni kljuc iz rsa private kljuceva.
for i in {1..100}; do 
    openssl rsa -in keys/kljuc$i.pem -inform PEM -pubout -out keys/public$i.pem; 
    if [[ "$(diff keys/public$i.pem prvizahtjev-pubkey.pem | awk 'NR==1')" == "" ]]; 
    then 
        echo "MATCH: kljuc$i.pem with prvizahtjev-pubkey.pem (CA key)"; 
    fi; 
    rm keys/public$i.pem; 
done 2>/dev/null
#Nije bilo podudaranja sto znaci da je rjesenje samo kljuc 50.
