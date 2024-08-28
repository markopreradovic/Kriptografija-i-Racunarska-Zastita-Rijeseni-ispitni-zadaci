#!/bin/bash

#Dekodujemo otisci.txt
mv otisci.txt otisci.base64
openssl enc -d -base64 -in otisci.base64 -out otisci.txt
#Dekodujemo izlaz.txt
mv izlaz.txt izlaz.base64
openssl enc -d -base64 -in izlaz.base64 -out izlaz.txt
#Dobili smo datoteku koja je enkriptovana i ima Salt.

#Lista simetricnih algoritama
openssl enc -ciphers | sed "1d" | tr -s " " "\n" | cut -c2- > symmetric.algos

#Kreiranje i provjera otisaka
OTISCI=$(cat otisci.txt)
while IFS= read -r algo
do
    OTISAK=$(openssl passwd -salt lozinka -1 $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -1 & salt 'lozinka' -> $OTISAK" && echo $algo >> decription-algos.list
    fi

    OTISAK=$(openssl passwd -salt 12 $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -crypt & salt '12' -> $OTISAK" && echo $algo >> decription-algos.list
    fi
    
    OTISAK=$(openssl passwd -salt 123456 -1 $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -1 & salt '123456' -> $OTISAK"  && echo $algo >> decription-algos.list
    fi
    
    OTISAK=$(openssl passwd -salt xy $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -crypt & salt 'xy' -> $OTISAK" && echo $algo >> decription-algos.list
    fi

    OTISAK=$(openssl passwd -salt abcdefgh -1 $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -1 & salt 'abcdefgh' -> $OTISAK" && echo $algo >> decription-algos.list
    fi

    OTISAK=$(openssl passwd -salt ab $algo)
    if [[ "$OTISCI" =~ "$OTISAK" ]]
    then
        echo "Match found: $algo password with algo -crypt & salt 'ab' -> $OTISAK" && echo $algo >> decription-algos.list
    fi
done < symmetric.algos

while IFS= read -r algo
do
    openssl $algo -d -in izlaz.txt -out ulaz1.txt -k $algo -pbkdf2
    openssl $algo -d -in ulaz1.txt -out ulaz2.txt -k $algo -pbkdf2
    openssl $algo -d -in ulaz2.txt -out ulaz.txt -k $algo -pbkdf2
    TEXT=$(cat ulaz.txt)
    rm ulaz*.txt
    if [[ "$TEXT" != "" ]]
    then
        echo "$algo + izlaz.txt 3x times = $TEXT"
    fi
done < decription-algos.list
