#!/bin/bash 
#Obe p12 datoteke su base64 kodovane
for i in {1..2}; do
    mv cert$i.p12 cert$i.p12.base64;
done

for i in {1..2}; do
    openssl enc -d -base64 -in cert$i.p12.base64 -out cert$i.p12;
done
rm *.base64

#Za serversku autentikaciju treba nam kljuc + sertifikat iz cert1.p12 datoteke. Sve sto treba da uradimo jeste da konvertujeo .p12 u .jks datoteku.
keytool -importkeystore -srckeystore cert1.p12 -srcstoretype pkcs12 -destkeystore server.jks -deststoretype jks -srcstorepass sigurnost -deststorepass sigurnost

#Izdvojimo kljuc iz cert2.p12
openssl pkcs12 -in cert2.p12 -nocerts -out private.enc -passin pass:sigurnost -passout pass:sigurnost
openssl rsa -in private.enc -out private.pem -passin pass:sigurnost

#Koristimo konf datoteku iz prethodnog zadatka za kreiranje dva nova klijenta sertifikata
#MANUELNO KOPIRAMO openssl.cnf
mkdir {private,requests,certs,newcerts,crl}
touch index.txt serial
echo 01 > serial

#Kreirajmo root CA
openssl req -new -x509 -key private.pem -out ca.pem -config openssl.cnf
mv private.pem private/
for i in {1..2}; do openssl genrsa -out private/key$i.pem 2048; done
for i in {1..2}; do openssl req -new -key private/key$i.pem -out request/req$i.csr -config openssl.cnf; done
for i in {1..2}; do openssl ca -in requests/req$i.csr -out certs/c$i.pem -config openssl.cnf; done

#Importujemo dva nova sertifikata u server.jks
for i in {1..2}; do 
keytool -import -alias K$i -file certs/c$i.pem -keystore server.jks -storepass sigurnost; 
done;

#Kreirajmo .p12 datoteku za klijentsku autentikaciju
openssl pkcs12 -export -in certs/c1.pem -out client.p12 -inkey private/key1.pem -certfile ca.pem -passout pass:sigurnost
#U server.xml dodamo sljedece:
#    <Connector port="8443" protocol="HTTP/1.1"
#               scheme="https"
#               secure="true"
#               SSLEnabled="true"    
#               server="Apache"
#               maxThreads="500" acceptCount="500"
#               keystoreFile="conf/server.jks"
#               keystorePass="sigurnost"
#               clientAuth="true"
#               truststoreFile="conf/server.jks" #moze i client.p12 kad se bude testiralo
#               truststorePass="sigurnost" />





