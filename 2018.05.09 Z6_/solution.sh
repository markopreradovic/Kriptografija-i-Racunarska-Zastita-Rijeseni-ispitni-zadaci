#!/bin/bash
openssl rsa -in kljuc1.key -out kljuc1-public.key -pubout
openssl rsa -in kljuc3.key -out kljuc3-public.key -pubout
openssl rsa -in kljuc4.key -out kljuc4-public.key -pubout
mv kljuc2.key kljuc2-public.key
mv kljuc5.key kljuc5-public.key
for i in {1..30}
do
    openssl enc -d -base64 -in potpis$i.sign -out potpis$i.bin
    for j in {1..5}
    do
        izlaz=`openssl dgst -sha224 -signature potpis$i.bin -verify kljuc$j-public.key ulaz.txt`
        if [ "$izlaz" == "Verified OK" ]  
        then
            echo "Rjesenje je potpis$i.txt"
            break
        fi
    done
done

