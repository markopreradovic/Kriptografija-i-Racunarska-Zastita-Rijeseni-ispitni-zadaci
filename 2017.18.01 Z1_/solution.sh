#!/bin/bash
mkdir dek
k=1
while [ $k -lt 251 ]; do
    openssl enc -base64 -d -in sifrat$k.txt -out dek/sifrat$k.txt
    openssl aes-192-cbc -d -in dek/sifrat$k.txt -out dek/tekst$k.txt -k sigurnost -md md5 2>error.txt
    ((k++))
done

i=1
otisak=$(<otisak.hash)
while [ $i -lt 251 ]; do
        hes=`openssl dgst -sha224 dek/tekst$i.txt | cut -d ' ' -f 2`
        if [ "$otisak" == "$hes" ]; then
            echo "tekst$i.txt"
            break
        fi
    ((i++))
done

