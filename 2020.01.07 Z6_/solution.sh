#!/bin/bash
mkdir keys
mv *.key keys/

#Dekodujemo obe datoteke
mv store.jks store-jks.base64
mv store.p12 store-p12.base64
openssl enc -d -base64 -in store-jks.base64 -out store.jks
openssl enc -d -base64 -in store-p12.base64 -out store.p12


mkdir store-{keys,certs}
#Procitamo sadrzaj p12 datoteke keytool list, imamo 5 sertifikata i root sertifikat
for i in {1..5}; do
    keytool -export -alias s$i -file store-certs/s$i.cer -keystore store.p12 -storepass sigurnost
done
#Izbacimo i root
keytool -export -alias root -file store-certs/s0.cer -keystore store.p12 -storepass sigurnost

openssl pkcs12 -info -in store.p12 -nokeys > store-p12.info

#Konvertujemo sertifikate iz der u pem
#Izbacimo iz njih sve javne kljuceve
for i in {1..5}; do
    openssl x509 -in store-certs/s$i.cer -pubkey -noout > store-keys/key-p12-$i.pem;
done

#Slicno uradimo i za jks datoteku
for i in {1..5}; do 
    keytool -export -alias s$i -file store-certs/s$i-jks.cer -keystore store.jks -storepass sigurnost; 
done

keytool -export -alias root -file store-certs/s0-jks.cer -keystore store.jks -storepass sigurnost

#Izbacimo iz njih sve javne kljuceve.
for i in {0..5}; do 
    openssl x509 -in store-certs/s$i-jks.cer -inform DER -pubkey -noout > store-keys/key-jks-$i.pem; 
done

#Pregledajmo kljuceve! Izgledaju kao RSA private kljucevi. Izdvojimo javne kljuceve koje cemo koristi za poredjenje.
mkdir keys/public
for i in {1..150}; do openssl rsa -in keys/key$i.key -pubout -out keys/public/key$i.pem; done


#POREDIMO KLJUCEVE
for i in {1..150} #150 datih kljuceva
do
    for j in {0..5} #JKS keys
    do
        DIFF=$(diff store-keys/key-jks-$j.pem keys/public/key$i.pem | awk 'NR==1')
        if [ "$DIFF" == "" ]
        then
            for k in {0..5} #P12 keys
            do
                DIFF=$(diff store-keys/key-p12-$k.pem keys/public/key$i.pem | awk 'NR==1')
                if [ "$DIFF" == "" ]
                then
                    echo "KEY $i is in both files, jks and p12."
                    break
                fi
            done
        fi
    done
done

#Dobijemo izlaz "KEY 126 is in both files, jks and p12.". Znaci rjesenje je key126.key. mozda je ovo rjesenje
#ja sam dobio
#diff: store-keys/key-p12-0.pem: No such file or directory
#KEY 11 is in both files, jks and p12.
#diff: store-keys/key-p12-0.pem: No such file or directory
#KEY 34 is in both files, jks and p12.
#diff: store-keys/key-p12-0.pem: No such file or directory
#KEY 39 is in both files, jks and p12.
#diff: store-keys/key-p12-0.pem: No such file or directory
#KEY 103 is in both files, jks and p12.
#diff: store-keys/key-p12-0.pem: No such file or directory
#KEY 126 is in both files, jks and p12.

