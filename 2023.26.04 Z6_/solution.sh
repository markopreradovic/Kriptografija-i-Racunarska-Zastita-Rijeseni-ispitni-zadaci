#!/bin/bash
for i in {1..50}; do
   keytool -exportcert -keystore keystore$i.jks -alias server -file c$i.pem -storepass sigurnost
   openssl x509 -in c$i.pem -noout -text
done
#Keystore 13 X509v3 Extended Key Usage:  
#TLS Web Server Authentication, TLS Web Client Authentication
#Jedini koji sadrzi oba ova

