#!/bin/bash
mkdir otisci
mv otisak* otisci/

#Preimenujemo naziv datoteka npr 01 u 1
for i in {1..9}; do
    mv otisci/otisak0$i.txt otisci/otisak$i.txt;
done

#Svi otisci su u base64, moramo dekodovati
for i in {1..11}; do
    mv otisci/otisak$i.txt otisci/otisak$i.txt.base64; 
done

for i in {1..11}; do
    openssl enc -d -base64 -in otisci/otisak$i.txt.base64 -out otisci/otisak$i.txt;
done

#Prikupljamo sve hash algoritme
openssl list --digest-commands | tr -s " " "\n" > algos.list

#Prolazimo kroz listu
while IFS= read -r algo 
do
    for i in {1..11}; do
        openssl dgst -$algo -out otisak.txt ulaz.txt
        if [[ "$(cat otisak.txt)" =~ "$(cat otisci/otisak$i.txt)" ]]
        then
            echo "MATCH: $algo - otisak$i.txt"
            rm otisak.txt
            break 2
        fi
        rm otisak.txt
    done
done < algos.list

#SHA384 - otisak7
