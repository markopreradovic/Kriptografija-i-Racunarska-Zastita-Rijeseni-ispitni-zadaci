#!/bin/bash
mkdir keys
mv *.key keys/
mkdir env
mv env*.txt env/

#sifrat.txt je u bse64
mv sifrat.txt sifrat.base64
openssl enc -d -in sifrat.base64 -out sifrat.txt
#Vidimo da je enkriptovan tekst Salt-ovan.

#Envelope su u base64, dekodujemo
for i in {1..20}; do
    mv env/env$i.txt env/env$i.base64
    openssl enc -d -in env/env$i.base64 -out env/env$i.txt
done

#Kljucevi su PEM formatu
#Dekripcija svih envelopa koristeci sve kljuceve. Kreiramo 20x20 datoteka gdje ce vecina biti prazne
mkdir env/aes-key
for i in {1..20}; do
    for j in {1..20}; do
        openssl rsautl -decrypt -in env/env$i.txt -out env/aes-key/env$i-key$j.txt -inkey keys/kljuc$j.key;
    done
done 2>/dev/null

#Brisemo prazne
find env/aes-key/* -size 0 -print -delete

#Ispis sadrzaja ostalih datoteka koje nisu prazne
for file in $(ls env/aes-key); do 
    echo -n "$file: " && cat env/aes-key/$file; 
done
#Dobijamo:
#env11-key20.txt: lozinka6
#env15-key7.txt: lozinka19
#env19-key17.txt: lozinka15
#env4-key12.txt: lozinka9
#env7-key3.txt: lozinka2
#Imamo ukupno 5 lozinki koje moramo testirati prilikom dekripcije sifrat.txt datoteke koristeci aes-256-ecb.

