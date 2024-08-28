#!/bin/bash

openssl enc -d -base64 -in sifrat.txt -out sifrat.dec

keys="kljuc*"

for key in $keys
do
    openssl rsa -in $key -out keys/$key -inform DER -outform PEM  2>error.txt
    #openssl rsa -in $key -out keys/$key -pubin -inform DER -outform PEM -pubout 2>error.txt
done

keys="keys/kljuc*"
for k in $keys
do
    izlaz=`openssl pkeyutl -decrypt -in sifrat.dec -inkey $k 2>error.txt`
    if [ "$izlaz" != "" ]
    then
        echo -e "Kljuc je: $k"
        echo -e "Sadrzaj je: $izlaz"
    fi
done



#Radi
