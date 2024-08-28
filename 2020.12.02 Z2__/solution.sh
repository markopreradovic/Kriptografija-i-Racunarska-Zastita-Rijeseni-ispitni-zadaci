#!/bin/bash
mkdir lozinke
mv lozinka*.txt lozinke

#Sifrat je u base64, dekodujemo
mv sifrat.txt sifrat.base64
openssl enc -d -base64 -in sifrat.base64 -out sifrat.txt

#Enkriptovan fajl je salt-ovan.

#Izdvojimo sve catst5 algoritme dostupne u openssl-u.
openssl enc -ciphers | sed 1d | tr -s " " "\n" | cut -c2- | grep cast5-* > cast5.algos

while IFS= read -r cast5
do
    for i in {0..30}
    do
        openssl $cast5 -d -in sifrat.txt -out ulaz1.txt -k lozinka$i -pbkdf2 -md md5
        openssl $cast5 -d -in ulaz1.txt  -out ulaz2.txt -k lozinka$i -pbkdf2 -md md5
        openssl $cast5 -d -in ulaz2.txt  -out ulaz3.txt -k lozinka$i -pbkdf2 -md md5
        TEXT=$(cat ulaz3.txt)
        rm ulaz*.txt
        if [ "$TEXT" != "" ]
        then    
            echo "$cast5 + lozinka$i - > $TEXT"
            break 2
        fi
    done
done < cast5.algos
