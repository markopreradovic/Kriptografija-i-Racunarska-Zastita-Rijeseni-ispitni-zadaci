#!/bin/bash
mkdir keys
mv *.key keys/

mkdir keys/public
for i in {1..150}; do
    openssl rsa -in keys/key$i.key -inform PEM -pubout -out keys/public/key$i.pem;
done

#PKCS12 DATOTEKE - U pkcs12 datoteci imamo 7 sertifikata (s1 - s6) i root
mkdir certs
openssl pkcs12 -in store.p12 -nokeys -cacerts -out certs/s0.pem -legacy -passout pass:sigurnost -passin pass:sigurnost
for i in {1..6}; do
    openssl pkcs12 -in store.p12 -nokeys -clcerts -out certs/s$i.pem -passin pass:sigurnost -passout pass:sigurnost -legacy
done

#Izvlacimo kljuceve
mkdir keystore-keys
for i in {0..6}; do
    openssl x509 -in certs/s$i.pem -pubkey -noout > keystore-keys/p12-key-s$i.pem;
done


#JKS DATOTEKE
#JKS datoteka ima s1-6 + root sertifikat. Slicna situacija kao i u p12.

keytool -importkeystore -srckeystore store.jks -destkeystore store1.p12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass sigurnost -deststorepass sigurnost

openssl pkcs12 -in store1.p12 -nokeys -cacerts -out certs/jks-s0.pem -legacy -passout pass:sigurnost -passin pass:sigurnost
for i in {1..6}; do
    openssl pkcs12 -in store.p12 -nokeys -clcerts -out certs/jks-s$i.pem -passin pass:sigurnost -passout pass:sigurnost -legacy
done 2>/dev/null

for i in {0..6}; do
    openssl x509 -in certs/jks-s$i.pem -pubkey -noout > keystore-keys/jks-key-s$i.pem;
done 2>/dev/null

#keytool -export -alias root -file certs/jks-s0.pem -keystore store.jks -storepass sigurnost
#for i in {1..6}; do
#    keytool -export -alias s$i -file certs/jks-s$i.pem -keystore store.jks -storepass sigurnost
#done 2>/dev/null

for i in {0..6}; do
    openssl x509 -in certs/jks-s$i.pem -pubkey -noout > keystore-keys/jks-key-s$i.pem;
done 2>/dev/null

for i in {1..150} # for public keys from keys/public/
do
    for j in {0..6} # for p12 keys
    do
        DIFF=$(diff keystore-keys/p12-key-s$j.pem keys/public/key$i.pem | awk 'NR==1')
        if [ "$DIFF" == "" ]
        then
            for k in {0..6} # for jks keys
            do
                DIFF=$(diff keystore-keys/jks-key-s$k.pem keys/public/key$i.pem | awk 'NR==1')
                if [ "$DIFF" == "" ]
                then
                    echo "Rjesenje: key$i.key"
                    #break 3
                fi
            done 2>/dev/null
        fi
    done 2>/dev/null
done 2>/dev/null

#Kljuc 86 i 98 - key86.key i key98.key su rjesenja zadatka, tj. to su kljuc koji se nalazi u obje datoteke, jks i pkcs12.
