#!/bin/bash
mkdir ulazi
mv ulaz*.txt ulazi/

#Dekodujemo otisak
openssl enc -d -base64 -in otisak.hash -out otisak.txt

#Lista hash algoritama
openssl list --digest-commands | tr -s " " "\n" > dgst.algos

while IFS= read -r algo
do
    for i in {1..20}
    do
        if [[ "$(openssl dgst -$algo ulazi/ulaz$i.txt)" =~ "$(cat otisak.txt)" ]]; then
            echo -n "Rjesenje ulaz$i.txt ($algo)"
            break 2
        fi
    done
done < dgst.algos
