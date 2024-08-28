#!/bin/bash

#Kljuc private4096. key je enkriptovan, moramo ukloniti nepotrebnu enkripciju
mv private4096.key private4096.encrypted
openssl rsa -in private4096.encrypted -inform PEM -out private4096.pem -outform pem -passin pass:sigurnost

mv private4096.key private/
mkdir {private,certs,newcerts,crl,requests}
touch index.txt crlnumber
echo 01 > serial

#Napravimo 3 kljuca
for i in {1..3}; do
    openssl genrsa -out private/key$i.pem 2048;
done

#Napravimo 3 zahtjeva od kojih 3. nije moguce potpisati (countryName primjenimo tako da ne bude match)
for i in {1..3}; do 
    openssl req -new -key private/key$i.pem -out requests/req$i.csr -config openssl.cnf;
done

#Prva dva su potpisana, dok treci nije uspio da se potpise
for i in {1..3}; do
    openssl ca -in requests/c$i.pem -out certs/c$i.pem -config openssl.cnf -days 365;
done

#Napravimo prvo drugu crl listu. Suspendujemo prvi sertifikat.
echo af > crlnumber
openssl ca -revoke certs/c1.pem -crl_reason cessationOfOperation -config openssl.cnf
openssl ca -gencrl -out crl/list2.pem -config openssl.cnf

#Suspendujemo drugi sertifikat pa onda kreiramo prvu crl listu
openssl ca -revoke certs/c2.pem -crl_reason certificateHold -config openssl.cnf
echo ab > crlnumber
openssl ca -gencrl -out crl/list1.pem -config openssl.cnf
