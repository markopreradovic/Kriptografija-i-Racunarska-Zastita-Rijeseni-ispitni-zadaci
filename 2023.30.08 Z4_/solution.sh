#!/bin/bash
for i in {1..30}; do
    rez=`openssl verify -CAfile cacert.pem clientcert$i.crt`
    if [[ "$rez" =~ "OK" ]]; then
        echo "klijent$i"
    fi
done

#rjesenje 16 18 20
