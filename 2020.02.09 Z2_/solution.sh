#!/bin/bash
mkdir ulaz
mv ulaz*.txt ulaz/

openssl enc -d -base64 -in otisak.txt -out otisak.dec

openssl list --digest-commands | tr -s " " "\n" | grep -E "sha[0-9]+" > sha.algos

while IFS= read -r sha
do
    for i in {1..10}
    do
        openssl dgst -$sha -out otisak-temp$i.txt ulaz/ulaz$i.txt
        OTISAK=$(cat otisak-temp$i.txt)
        if [[ "$OTISAK" =~ "88c84e5e8c8dd603d638109f0a7ab61381e3cb1bcd080895cf65cdfae64dac3260e2ed77c4b9f317d52978280cd433c6" ]]
        then
            echo "Rjesenje je ulaz$i.txt sa $sha"
            break
        fi
        rm otisak-temp$i.txt
    done
done < sha.algos
#Rjesenje je ulaz5.txt sa sha384

