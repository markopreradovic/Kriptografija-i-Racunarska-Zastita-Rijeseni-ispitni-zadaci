#!/bin/bash

for i in {1..30}; do
    provjera=`openssl verify -CAfile cacert.pem clientcert$i.crt`
    if [[ "$provjera" =~ "OK" ]]; then
        echo "Sertifikat $i JE VALIDAN"
    fi
done
