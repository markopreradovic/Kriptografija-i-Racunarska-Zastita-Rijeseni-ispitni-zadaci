#!/bin/bash
mkdir keys
mv *.key keys/

#Potrebno je preimenovati prvih 9 kljuceva iz klju0n u kljucn radi lakseg rada prilikom koristenja for petlje.
for i in {1..9}; do mv keys/kljuc0$i.key keys/kljuc$i.key; done

#Svi kljucevi su RSA i u PEM formatu
openssl pkcs12 -in cert.pfx -nocerts -out priv-pass_protected.key -passin pass:sigurnost -passout pass:sigurnost -legacy

#Ovo je enkriptovan kljuc zasticen lozinkom pa je datoteka drugacija. Konvertujemo ga u .key

openssl rsa -in priv-pass_protected.key -out priv.key -passin pass:sigurnost
mkdir private
for i in {1..20}; do
    if [[ "$(diff priv.key keys/kljuc$i.key)" == "" ]];
    then
        echo "Match: kljuc$i"
        mv keys/kljuc$i.key private/private,key
    fi
done

##NECE DALJE RADI, KLJUCEVI SE RAZLIKUJU, MOGUCE DA SU RAZLICITI ALGORITMI KORISTENI
