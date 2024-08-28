#!/bin/bash

#lista.crl je u der formatu
openssl crl -in lista.crl -inform der -outform pem -out lista.crl

#ca.pem je u der formatu
openssl x509 -in ca.pem -inform der -outform pem -out ca.pem

mkdir {certs,newcerts,crl,requests,private}
touch index.txt crlnumber serial
#Nije dat privatni kljuc ca.pem-a

#Kreirajmo 5 kljuceva
for i in {1..4}; do
    openssl genrsa -out private/key$i.pem 2048; 
done
openssl genrsa -out private/private4096-new.key 4096 #za novo CA tijelo koje kasnije kreiramo

#Za s1.cer
#basicConstraints=CA:FALSE
#keyUsage=cRLSign
echo aa > serial
openssl req -new -key private/key1.pem -out requests/req1.csr -config openssl.cnf
openssl ca -in requests/req1.csr -out certs/s1.pem -config openssl.cnf -days 21

#Za s2.cer
#basicConstraints=CA:TRUE
#keyusage=keyAgreement
#extendedKeyUsage=clientAuth
echo 2a > serial
openssl req -new -key private/key2.pem -out requests/req2.csr -config openssl.cnf
openssl ca -in requests/req2.csr -out certs/s2.pem -config openssl.cnf -days 36500

#Kreirajmo novo root CA tijelo
mv ca.pem ca_old.pem
#Podesimo openssl.cnf da odgovara zahtjevu
#Zahtjev:Generisati novi CA sertifikat, u kojem će obavezno biti navedene tri vrijednosti za atribut grad, svaka
#dužine između 5 i 15 karaktera.
#localityName               = Locality Name (eg, city)
#localityName_0             = City1
#localityName_0_default     = Novi Sad
#localityName_1             = City2
#localityName_1_default     = Subotica
#localityName_2             = City3
#localityName_2_default     = Sombor
mv private/private4096.key private/private4096-old.key
mv private/private4096-new.key private/private4096.key
openssl req -x509 -new -key private/private4096.key -out ca.pem -config openssl.cnf 

#s3 i s4 potpisuje novi ca.pem
#Za s3.cer:
#keyUsage = decipherOnly
#extendedKeyUsage=serverAuth
echo 66 > serial
#Ne smije da sadrzi informacije o organizaciji, OSTAVITI PRAZNO
openssl req -new -key private/key3.pem -out requests/req3.csr -config openssl.cnf
openssl ca -in requests/req3.csr -out certs/s3.cer -config openssl.cnf -days 4

za s4.cer:
#keyUsage = keyAgreement
echo 2a > serial
openssl req -new -key private/key4.pem -out requests/req4.csr -config openssl.cnf 
openssl ca -in requests/req4.csr -out certs/s4.cer -config openssl.cnf -days 36500

#Postojeca lista ne moze da se iskoristi za povlacenje sertifikata u openssl-u!
openssl ca -revoke certs/s3.cer -crl_reason affiliationChanged -config openssl.cnf 
#Kreirajmo lista2.crl.
echo ed > crlnumber
openssl ca -gencrl -out crl/lista2.crl -config openssl.cnf -days 311

openssl ca -revoke certs/s2.pem -crl_reason certificateHold -config openssl.cnf
openssl ca -gencrl -out crl/lista1.crl -config openssl.cnf







