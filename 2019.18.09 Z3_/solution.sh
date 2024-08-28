#!/bin/bash
keys="kljuc*"
texts="tekst*"
algos="sha1 sha224 sha256 sha384 sha512 whirlpool"

for key in $keys
do

    #Razvrstavanje kljuceva, ima i DSA i RSA
    
    if [[ `openssl rsa -in $key -inform DER -noout -text 2>error1.txt` != "" ]]
    then
        openssl rsa -in $key -out $key.pem -inform DER -outform PEM
    fi

    if [[ `openssl dsa -in $key -inform DER -noout -text 2>error1.txt` != "" ]]
    then
        openssl dsa -in $key -out $key.pem -inform DER -outform PEM
    fi

    for text in $texts
    do
        for algo in $algos
        do
        
        rezultat2=`openssl dgst -$algo -prverify $key -signature potpis.txt $text 2>error3.txt`

        if [ "$rezultat2" = "Verified OK" ]
        then
            echo $key
            echo $text
            echo $algo
        fi
        
        done
    done
done
