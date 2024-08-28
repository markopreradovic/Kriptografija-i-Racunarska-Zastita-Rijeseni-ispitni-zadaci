#!/bin/bash
mkdir {newcerts,certs,private,requests,crl}
touch index.txt crlnumber
echo 01 > serial

#Premjestimo date kljuceve u odgovarajuci direktorijum.
mv priv*.key private/

#Kreirajmo kljuc private4096.key i samopotpisujuci sertifikat ca.pem sa kojim cemo potpisati ca1.cer i ca2.cer.
openssl genrsa -out private/private4096.key 2048
#Politiku pseudonym = match iz openssl.cnf datoteke je potrebno obrisati. Ovo mozemo uraditi jer zadatkom nije zabranjena izmjena politike. Ostalo popunjavamo prema podesavanjim u openssl.cnf.
#Dodajemo sljedece politike surname, title.
#Potrebno je napraviti izmjene u default_keyfile i dir polju.
openssl req -x509 -new -key private/private4096.key -out ca.pem -config openssl.cnf

#Polje organizacije setujemo na match jer cemo na kraju trebati kreirati zahtjev koji ce imati istu vrijednost polja kao i ca2.cer. Polje surname koje je obavezno i bice ostavljeno praznim kod popunjavanja csr-a jer zadatak trazi da kreiramo zahtjev koji nece moci biti potpisan od strane ca1.cer i ca2.cer.

#Generisimo 2 zahtjeva koja cemo zatim potpisati da bi dobili ca1.cer i ca2.cer. ca1.cer mora imati mogucnost potpisivanja klijentskih serifikata. Trebao izmjeniti sljedece: basicConstraints=CA:TRUE i keyUsage mora biti  digitalSignature. Potrebno je dodati i titulu polje koje mora imati defaultnu vrijednost, tj. mora biti match.

for i in {1..2}; do openssl req -new -out requests/req$i.csr -key private/priv$i.key -config openssl.cnf -days 365; done
for i in {1..2}; do openssl ca -in requests/req$i.csr -out certs/ca$i.cer -config openssl.cnf -days 365; done

#Sada kopiramo ca1.pem u root direktorijum i zamijenimo ca.pem sa ca1.pem i odgovarajuci kljuc unutar openssl.cnf datoteke.
mv certs/ca1.cer .

#Napravimo tri kljuca, za k1.cer, k2.cer i k3.cer.
for i in {1..3}; do openssl genrsa -out private/private-k$i.key 2048; done

#Za k1.cer:
#Potreno izmjeniti openssl.cnf tako da ca1.cer moze potpisati k1 i k2 sertifikat. Mijenjamo certificate private_key i default_keyfile polje.

#basicConstraints=CA:FALSE
#keyUsage = nonRepudiation
#extendedKeyUsage = clientAuth

echo 22 > serial
openssl req -new -out requests/req-k1.csr -key private/private-k1.key -config openssl.cnf
openssl ca -in requests/req-k1.csr -out certs/k1.cer -config openssl.cnf -days 365

#Za k2.cer:
#keyUsage = encipherOnly
echo 24 > serial
openssl req -new -out requests/req-k2.csr -key private/private-k2.key -config openssl.cnf 
openssl ca -in requests/req-k2.csr -out certs/k2.cer -config openssl.cnf -days 3650

mv certs/ca2.cer .

#Za k3.cer:
#Potreno izmjeniti openssl.cnf tako da ga ca2.cer moze potpisati. Mijenjamo certificate private_key i default_keyfile polje.
#basicConstraints=CA:TRUE
echo f1 > serial
openssl req -new -out requests/req-k3.csr -key private/private-k3.key -config openssl.cnf
openssl ca -in requests/req-k3.csr -out certs/k3.cer -config openssl.cnf -days 90

#Generisemo zahtjev invalid.req koji necemo moci potpisati ni sa jednim, ca1.cer ili ca2.cer, sertifikatom. Prilikom popunjavanja polja ostavimo surname i commonName praznim jer su to obavezno polja i mozemo pod organizationName i title unijeti nesto sto nije match sa default-nom vrijednosti. Potrebno je generisati kljuc za ovaj zahtjev.
openssl genrsa -out private/invalid.key 2048
openssl req -new -out requests/invalid.req -key private/invalid.key -config openssl.cnf 
#Pokusajmo potpisati zahtjev.
openssl ca -in requests/invalid.req -out certs/invalid.cer -config openssl.cnf
#Nije prosao potpis.


