#!/bin/bash
for i in {1..5}; do
    for j in {1..30}; do
        potpis=`openssl dgst -sha224 -sign kljuc$i.key -keyform PEM ulaz.txt | openssl enc -base64`
        provjera=`cat potpis$j.sign`
        if [ "$potpis" = "$provjera" ]; then
            echo "potpis$j + kljuc$i"
            break
        fi    
    done
done    
