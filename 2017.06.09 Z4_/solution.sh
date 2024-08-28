#!/bin/bash
openssl enc -d -base64 -in sifrat.txt -out sifrat1.txt
for i in {1..200}; do
    openssl rsa -in kljuc$i.key -inform DER -outform PEM -out kljuc$i.pem
    openssl pkeyutl -decrypt -inkey kljuc$i.pem -in sifrat1.txt -out sifratX$i.txt 2>>error.txt
    echo "SIFRAT$i:  "    
    echo "$(cat sifratX$i.txt)"
done

#SIFRAT153:  
#ovo je ulazna datoteka

