#!/bin/bash
mkdir ulaz
mv ulaz*.txt ulaz/

#openssl enc -d -base64 -in otisak.txt -out otisak.dec

for i in {1..20}
do
    otisak=$(openssl passwd -1 -salt ... ulaz$i.txt)
    if [[ "$otisak" =~ "XkqITdBoh/5De0Fa3JAwD/" ]]
    then
        echo "Rjesenje je ulaz$i.txt"
        break
    fi
done
#Rjesenje je ulaz16.txt
