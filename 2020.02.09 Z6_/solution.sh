#!/bin/bash
mkdir stores 
mv store*.p12 stores/

#kljuc.key je public
mkdir -p keys/public

#Izbacimo private kljuc iz svih p12 datoteka
for i in {1..50}; do
    openssl pkcs12 -in stores/store$i.p12 -nocerts -out keys/key$i.pem -passin pass:sigurnost -passout pass:sigurnost;
done

#Izbacimo iz privatnih kljuceva javne
for i in {1..50}; do
    openssl rsa -in keys/key$i.pem -pubout -out keys/public/pub-key$i.pem -passin pass:sigurnost
done 2>/dev/null

#Pronalazimo match
for i in {1..50}; do
    DIFF=$(diff kljuc.key keys/public/pub-key$i.pem)
    if [  "$DIFF" == "" ]
    then
        echo "MATCH store$i.p12"
        cp stores/store$i.p12 .
        break
    fi
done

#Dobijamo poruku "Match found. Key is located in store39.p12 file"

mkdir {certs,requests,private,crl,newcerts}
touch index.txt crlnumber
echo ba > serial

#Trebamo koristiti pkcs12 datoteku da kreiramo CA tijelo. To znaci da koristimo privatni kljuc za njegovo kreiranje iz pkcs12 datoteke.
cp keys/key39.pem private/private.key

#Podesavamo openssl.cnf datoteku i kreiramo CA tijelo
openssl req -x509 -new -key private/private.key -out ca.pem -config openssl.cnf

#Kreirajmo kljuceve i zahtjeve
for i in {1..2}; do
    openssl genrsa -out private/key$i.pem 2048
done

for i in {1..2}; do
    openssl req -new -key private/key$i.pem -out requests/req$i.csr -config openssl.cnf;
done

#Za prvi sertifikat:
#basicConstraints=CA:TRUE
#keyUsage = keyAgreement
openssl ca -in requests/req1.csr -config openssl.cnf -out certs/s1.cer -days 365
#Za drugi sertifikat:
#basicConstraints=CA:FALSE
#keyUsage = nonRepudiation
#extendedKeyUsage = clientAuth, serverAuth
echo ab > serial
openssl ca -in requests/req2.csr -config openssl.cnf -out certs/s2.cer -days 36500
#Suspendujmo s1.cer i napravimo crl listu.
openssl ca -revoke certs/s1.cer -crl_reason unspecified -config openssl.cnf 
echo 01 > crlnumber
opensssl ca -gencrl -out crl/lista.crl -config openssl.cnf














