#!/bin/bash
mkdir keys 
mv *.key keys/

#Svi kljucevi su RSA privatni u PEM formatu
#keystore ima 6 unos (5 sertifikata i jedan kljuc)

mkdir certs
keytool -export -alias cer41 -file certs/cer1.crt -keystore store.jks -storepass sigurnost
keytool -export -alias cer85 -file certs/cer2.crt -keystore store.jks -storepass sigurnost
keytool -export -alias cer142 -file certs/cer3.crt -keystore store.jks -storepass sigurnost
keytool -export -alias cer63 -file certs/cer4.crt -keystore store.jks -storepass sigurnost
keytool -export -alias cer99 -file certs/cer5.crt -keystore store.jks -storepass sigurnost

#Svi sertifikati su u DER formatu


mkdir public-keys
for i in {1..5}; do
    openssl x509 -in certs/cer$i.crt -inform DER -pubkey -noout > public-keys/public$i.key
done

#Da bi smo dosli do privatnog kljuca moramo prvo jks konvertovati u p12 datoteku pa onda izbaciti kljuc.
keytool -importkeystore -srckeystore store.jks -destkeystore store.p12 -srcstoretype jks -deststoretype pkcs12 -srcstorepass sigurnost -deststorepass sigurnost

#Izbacujemo kljuc
openssl pkcs12 -in store.p12 -nocerts -out private.key -passin pass:sigurnost -passout pass:sigurnost

#Konverotvanja privatnog enkriptovanog kljuca u privatni kljuc.
openssl rsa -in private.key -out private.pem -passin pass:sigurnost
openssl rsa -in private.pem -pubout -out public-keys/public0.key

mkdir keys/public
#Ekstraktujemo javne kljuceve iz datih privatnih radi poredjenja
for i in {0..150}; do
    openssl rsa -in keys/key$i.key -pubout -out keys/public/pub$i.pem
done

for i in {0..150}
do
    for j in {0..5}
    do
        if [ "$(diff keys/public/pub$i.pem public-keys/public$j.key | awk 'NR==1')" == "" ]
        then
            echo "MATCH FOUND: key$i.key"
        fi
    done
done

#MATCH FOUND: key34.key
#MATCH FOUND: key100.key
