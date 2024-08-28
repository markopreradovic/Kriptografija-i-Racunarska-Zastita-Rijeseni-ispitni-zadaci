#!/bin/bash
openssl enc -d -base64 -in otisak.txt -out otisak.sign
for i in {1..50}; do
    potpis1=`openssl dgst -sha384 keystore$i.jks | cut -d ' ' -f 2 2>error.txt`
    potpis2=`openssl dgst -sha3-384 keystore$i.jks | cut -d ' ' -f 2 2>error.txt`
    if [[ "$(cat otisak.sign)" == "$potpis1" ]]; then
        echo "RJESENJE keystore$i"
    fi

    if [[ "$(cat otisak.sign)" == "$potpis2" ]]; then
        echo "RJESENJE keystore$i"
    fi
done
#RJESENJE keystore5

