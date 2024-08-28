#!/bin/bash

mkdir certs && mv *.crt certs/

#store.jks je base64 kodovana
mv store.jks store.jks.base64
openssl enc -d -base64 -in store.jks.base64 -out store.jks

for i in {1..24}; 
do
    openssl x509 -in certs/cert$i.crt -inform DER -out certs/cert$i.pem -outform pem;
    rm certs/cert$i.crt;
done 2>/dev/null

#izlistavamo sadrzaj JKS datoteke   
keytool -list -keystore store.jks -storepass sigurnost
#.jks datoteka ima dva sertifikata + root. Sve ih izdvajamo.
keytool -exportcert -alias a -keystore store.jks -file a.pem -storepass sigurnost
keytool -exportcert -alias b -keystore store.jks -file b.pem -storepass sigurnost
keytool -exportcert -alias root -keystore store.jks -file root.pem -storepass sigurnost

#Sertifikati su u DER formatu
openssl x509 -in a.pem -inform DER -outform PEM -out a.pem
openssl x509 -in b.pem -inform DER -outform PEM -out b.pem
openssl x509 -in root.pem -inform DER -outform PEM -out root.pem

#Uporedimo sertifikate
for i in {1..24}; 
do
    if [[ "$(diff certs/cert$i.pem a.pem | awk 'NR==1')" == "" ]]; then
    echo "a.pem match cert$i";
    elif [[ "$(diff certs/cert$i.pem b.pem | awk 'NR==1')" == "" ]]; then
    echo "b.pem match cert$i";
    elif [[ "$(diff certs/cert$i.pem root.pem | awk 'NR==1')" == "" ]]; then
    echo "root.pem match cert$i"; 
    fi; 
done 2>/dev/null

#a.pem match cert6
#a.pem match cert11
#b.pem match cert12
#a.pem match cert13
#a.pem match cert16
#b.pem match cert17
