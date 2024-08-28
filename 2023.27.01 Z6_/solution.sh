#!/bin/bash
for i in {1..50}; do
    keytool -keystore keystore$i.jks -list -storepass sigurnost
    keytool -exportcert -keystore keystore$i.jks -alias server -file sertifikati/s$i.pem -storepass sigurnost
    openssl x509 -in sertifikati/s$i.pem -noout -text
done
#Certificate stored in file <sertifikati/s22.pem>

