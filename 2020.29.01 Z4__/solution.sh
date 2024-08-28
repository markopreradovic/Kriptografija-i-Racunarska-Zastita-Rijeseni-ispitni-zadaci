#!/bin/bash
mkdir {certs,newcerts,requests,crl,private}
touch index.txt crlnumber
echo 01 > serial

#ca.pem je u DER formatu, moramo konvertovati u PEM
openssl x509 -in ca.der -inform DER -out ca.pem -outform PEM 
rm ca.der

#Problem: nije dosao privatni kljuc od ca.pem-a.
#Treba obrisati givenName iz openssl.cnf-a i polja organizacije oznaciti optional i izbaciti default vrijednosti zbog 3. sertifikata koji ima prazna polja za organizaciju.

#Pravimo tri nova RSA kljuca
for i in {1..3}; do openssl genrsa -out private/key$i.pem 2048; done

#Prvi sertifikat:
#Ne smije biti CA, keyUsage = keyAgreement, potpisan na 365 dana
openssl req -new -key private/key1.pem -out requests/req1.csr -config openssl.cnf 
echo bb > serial
openssl ca -in requests/req1.csr -out certs/s1.cer -config openssl.cnf -days 365

#Treci sertifikat:
#Ostaviti polja za organizaciju prazna, keyUsage = encipherOnly, 20 dana
openssl req -new  -key private/key3.pem -out requests/req3.csr -config openssl.cnf 
echo 66 > serial
openssl ca -in requests/req3.csr -out certs/s3.cer -config openssl.cnf -days 20

#Drugi sertifikat:
#CA sertifikat, keyUsage = nonRepudiation, extendedKeyUsage = serverAuth, 5 godina 
openssl req -new -key private/key3.pem -out requests/req3.csr -config openssl.cnf -days 1825

#Zahtjev koji nije moguce potpisati.
#Kako polje countryName mora biti match, ako unesemo nesto osim BA, dobijamo csr koji nije moguce potpisati.
#Kreirajmo prvo kljuc pa onda csr koji cemo zatim pokusati potpisati.
openssl genrsa -out private/key4.pem 2048
openssl req -new -key private/key4.pem -out requests/invalid.req -config openssl.cnf
openssl ca -in requests/invalid.req -out certs/s4.cer -config openssl.cnf

#Povucimo sertifikate i generimo crl listu.
openssl ca -revoke certs/s1.cer -crl_reason unspecified -config openssl.cnf 
openssl ca -revoke certs/s2.cer -crl_reason CACompromise -config openssl.cnf 
openssl ca -revoke certs/s3.cer -crl_reason certificateHold -config openssl.cnf 

openssl ca -gencrl -out crl/lista.crl -config openssl.cnf 
