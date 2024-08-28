#!/bin/bash
mkdir {certs,newcerts,crl,private,requests}
touch index.txt crlnumber
echo 01 > serial

#Kreirajmo tri nova kljuca
for i in {1..3}; do
    openssl genrsa -out private/key$i.pem 2048;
done;

#Kreirajmo tri zahtjeva
for i in {1..3}; do
    openssl req -new -key private/key$i.pem -out requests/req$i.csr -config openssl.cnf;
done;

#Potpisimo tri zahtjeva
openssl ca -in requests/req1.csr -out certs/cert1.pem -config openssl.cnf
openssl ca -in requests/req2.csr -out certs/cert2.pem -config openssl.cnf
openssl ca -in requests/req3.csr -out certs/cert3.pem -config openssl.cnf

#Napravimo backup index.txt za laksi reset povucenih sertifikata
cp indext.txt index-backup.txt 

#Napravimo drugu crl listu, prvo povucimo prvi sertifikat
echo 1d > crlnumber
openssl ca -revoke certs/cert1.pem -crl_reason affiliationChanged -config openssl.cnf
openssl ca -gencrl -out crl/list2.pem -config openssl.cnf -days 406

#Napravimo prvu crl listu. Povucimo i treci sertifikat.
echo 1b > crlnumber
openssl ca -revoke certs/cert3.pem -crl_reason certificateHold -config openssl.cnf
openssl ca -gencrl -out crl/list1.pem -config openssl.cnf -days 406

#Reaktivarajmo treci sertifikat koristeci bakcup koji smo ranije kreirali. Zatim, povlacimo 2. i 3. sertifikat.
echo 1e > crlnumber
openssl ca -revoke certs/cert2.pem -crl_reason affiliationChanged -config openssl.cnf
openssl ca -revoke certs/cert3.pem -crl_reason affiliationChanged -config openssl.cnf
openssl ca -gencrl -out crl/list3.pem -config openssl.cnf
