#!/bin/bash

i=1

#Konvertujemo JKS u PKCS12
while [ $i -lt 101 ]; do
    `keytool -importkeystore -srckeystore store$i.jks -destkeystore store$i.p12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass sigurnost -deststorepass sigurnost`
    ((i++))
done

j=1

#Izdvaja se privatni kljuc iz PKCS12 datoteke
while [ $j -lt 101 ]; do
    `openssl pkcs12 -in store$j.p12 -nocerts -out key$j.key -passin pass:sigurnost -passout pass:sigurnost`
    ((j++))
done

k=1

#Generisanje javnog RSA kljuca iz privatnog RSA kljuca
while [ $k -lt 101 ]; do
    `openssl rsa -in key$k.key -pubout -out pubkey$k-RSA.key -passin pass:sigurnost -passout pass:sigurnost`
    ((k++))
done

f=1
while [ $f -lt 101 ]; do
    u=1
    while [ $u -lt 101 ]; do
        verifikacija=`openssl dgst -sha1 -verify pubkey$f-RSA.key -signature signature.bin ulaz$u.txt`
        if [ "$verifikacija" = "Verified OK" ]; then
            echo "pubkey$f-RSA.key"
            echo "ulaz$u.txt"
            u=100
            f=100
        fi
        ((u++))
    done
    ((f++))
done

#Rjesenje: ulaz69.txt pubkey69-RSA.key store69.p12 store69.jks
