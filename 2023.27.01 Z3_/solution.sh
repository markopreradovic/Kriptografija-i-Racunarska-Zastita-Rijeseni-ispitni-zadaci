#!/bin/bash
for i in {1..30}; do
    ver=`openssl verify -CAfile cacert.pem clientcert$i.crt`
    if [[ "$ver" =~  "OK" ]]; then
        echo "RJESENJE: cert$i"
    fi
done
#Rjesenje 15 27 29
