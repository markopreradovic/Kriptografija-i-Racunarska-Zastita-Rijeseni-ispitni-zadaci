#!/bin/bash

#mkdir certs
#for i in {1..6}; do
#    keytool -export -alias s$i -file certs/s1$i.cer -keystore store.jks -storepass sigurnost
#    keytool -export -alias s$i -file certs/s2$i.cer -keystore store.p12 -storepass sigurnost
#done

for i in {1..100}; do
    openssl rsa -in key$i.key -out javni.key -pubout
    for j in {1..6}; do
        openssl x509 -in certs/s1$j.cer -noout -pubkey > javni1.key
        if [[ "$(cat javni.key)" == "$(cat javni1.key)" ]]; then
            for k in {1..6}; do
                openssl x509 -in certs/s2$k.cer -noout -pubkey > javni2.key
                if [[ "$(cat javni.key)" == "$(cat javni2.key)" ]]; then
                    echo "RJESENJE Kljuc$i"
                fi
            done
        fi
     done
done
#KLJUC 13 i 94
