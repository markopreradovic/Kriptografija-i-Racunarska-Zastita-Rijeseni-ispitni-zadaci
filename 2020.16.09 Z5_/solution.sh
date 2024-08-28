#!/bin/bash

#Za dobijanje tacnog fajla
#for i in {1..10}
#do
#    OTISAK=$(openssl passwd -1 -salt ________  store$i.p12)
#    if [[ "$OTISAK" =~ "thXLGgfGaW2ar6Gq5WaZV" ]]
#    then
#        echo "Tacan fajl je store$i.p12"
#    fi
#done

#STORE8

mkdir stores
mv *.p12 stores/
#Izbacimo kljuc iz store8
openssl pkcs12 -in stores/store8.p12 -nocerts -out private.key -legacy

mkdir {certs,newcerts,requests,private,crl}
touch index.txt crlnumber
echo 01 > serial
mv private.key private/

#Pravimo samopotpisujuci sertifikat koristeci kljuc iz p12 datoteke
openssl req -x509 -new -key private/private.key -out rootCA.pem -config openssl.cnf

#3 klijentska sertifikata, extendedKeyUsage=clientAuth
for i in {1..4} do
    openssl genrsa -out private/key$i.pem 2048
done

for i in {1..3} do
    openssl req -new -key private/key$i.pem -out requests/req$i.csr -config openssl.cnf
done

for i in {1..3} do
    openssl ca -in requests/req$i.csr -config openssl.cnf -out certs/c$i.pem
done
mkdir -p solution/{server,client}
cp certs/c{1..3}.pem solution/client/
cp certs/c4.pem solution/server/

#Serverski sertifikat, extendedKeyUsage=serverAuth
openssl -req -new private/key$i.pem -out requests/req4.csr -config openssl.cnf
openssl ca -in requests/req4.csr -config openssl.cnf -out certs/c4.pem

openssl pkcs12 -export -out solution/server/server.p12 -inkey private/key4.pem -in solution/server/c4.pem -certfile rootCA.pem

keytool -importkeystore -srckeystore solution/server/server.p12 -destkeystore solution/server/server.jks -srcstoretype pkcs12 -deststoretype jks -srcstorepass sigurnost -deststorepass sigurnost

#Za klijentsku autentikaciju napravimo jednu client.p12
openssl pkcs12 -export -out solution/client/client.p12 -in solution/client/c1.pem -certfile rootCA.pem
