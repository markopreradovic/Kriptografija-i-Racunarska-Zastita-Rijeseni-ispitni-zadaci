#!/bin/bash

keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s5 -file s5.cer1
keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s4 -file s4.cer1
keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s3 -file s3.cer1
keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s2 -file s2.cer1
keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s1 -file s1.cer1
keytool -keystore store.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias root -file root1.cer1

keytool -importkeystore -srckeystore store.jks -srcstoretype jks -destkeystore store1.p12 -deststoretype pkcs12 -srcstorepass sigurnost -deststorepass sigurnost

keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s1 -file s1.cer2
keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s2 -file s2.cer2
keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s3 -file s3.cer2
keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s4 -file s4.cer2
keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias s5 -file s5.cer2
keytool -keystore store1.p12 -storetype pkcs12 -storepass sigurnost -exportcert -alias root -file root2.cer2

kljucevi="*.key"
sertifikati="*.cer1 *.cer2"
i=0
for kljuc in $kljucevi
do
    for cer in $sertifikati
    do
        openssl rsa -in $kljuc -out publicKey.pem -inform PEM -pubout

        openssl x509 -in $cer -out c.pem -inform DER -outform PEM

        openssl x509 -in c.pem -pubkey -noout > publicKeyCert.pem
    
        if [ "`cat publicKeyCert.pem`" == "`cat publicKey.pem`" ]
        then
            echo -en "\n \t\t\t"$kljuc "\n \n"
            i=`expr $i + 1`
            echo -en "$i" > file.txt
        fi
    done
done

#113 x 2 - > nalazi se u obe datoteke
