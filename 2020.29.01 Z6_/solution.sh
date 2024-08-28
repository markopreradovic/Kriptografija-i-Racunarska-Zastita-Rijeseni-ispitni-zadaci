#!/bin/bash
mkdir certs
mv cert*.crt certs/

#Sertifikati su u der formatu, konvertujemo u pem
for i in {1..23}; do
    openssl x509 -in certs/cert$i.crt -out certs/cert$i.pem -inform DER -outform PEM
done

#store.jks je base64, moramo dekodovati, pa izbaciti sve dostupne sertifikate
mv store.jks store.base64
openssl enc -d -base64 -in store.base64 -out store.jks

mkdir jks-certs
keytool -export -alias a -file jks-certs/s1.crt -keystore store.jks -storepass sigurnost
keytool -export -alias b -file jks-certs/s2.crt -keystore store.jks -storepass sigurnost
keytool -export -alias c -file jks-certs/s3.crt -keystore store.jks -storepass sigurnost
keytool -export -alias root -file jks-certs/s4.crt -keystore store.jks -storepass sigurnost

for i in {1..4} 
do
    for j in {1..23}
    do
        if [ $j == 11 ]; then continue;
        elif [ $j == 13 ]; then continue; fi
        if [ "$(diff jks-certs/s$i.crt certs/cert$j.crt)" == "" ]
        then
            echo "MATCH: s$i.crt <-> cert$j.crt"
        fi
    done
done
#MATCH: s1.crt <-> cert4.crt
#MATCH: s1.crt <-> cert16.crt
#MATCH: s2.crt <-> cert12.crt
#MATCH: s2.crt <-> cert21.crt

