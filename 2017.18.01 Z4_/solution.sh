#!/bin/bash
for i in {1..5}; do
    openssl rsa -in kljuc$i.key -inform PEM -out kljuc$i.public -pubout
done

for i in {1..30}; do
    openssl enc -base64 -d -in potpis$i.sign -out dpotpis$i.txt
done

for i in {1..5}; do
    for j in {1..30}; do
        echo "kljuc $i"
        echo "potpis $j"
        openssl dgst -sha224 -verify kljuc$i.public -signature dpotpis$i.txt ulaz.txt
    done
done

