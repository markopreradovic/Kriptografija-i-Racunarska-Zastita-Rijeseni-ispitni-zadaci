#!/bin/bash
openssl enc -d -base64 -in otisak1.txt -out Xotisak1.txt 
openssl enc -d -base64 -in otisak2.txt -out Xotisak2.txt 
openssl enc -d -base64 -in otisak3.txt -out Xotisak3.txt 
openssl enc -d -base64 -in sifrat.txt -out sifratX.txt
for i in {0..30}; do
    pas1=`openssl passwd -apr1 -salt lozinka1 lozinka$i`
    pas2=`openssl passwd -apr1 -salt lozinka7 lozinka$i`
    pas3=`openssl passwd -apr1 -salt wAgnh5WA lozinka$i`
    for j in {1..3}; do
        tekst=`cat Xotisak$j.txt`
        if [ "$pas1" = "$tekst" ]; then
            echo "Kljuc - lozinka$i - $j"
        elif [ "$pas2" = "$tekst" ]; then
            echo "Kljuc - lozinka$i - $j"
        elif [ "$pas3" = "$tekst" ]; then
            echo "Kljuc - lozinka$i - $j"
        fi
    done
done

tekst="aes-256-cbc       aes-256-ecb"
alg=(${tekst})
for i in {0..2}; do
    echo "${alg[i]}"
    openssl ${alg[i]} -d -in sifratX.txt -salt -out sifrat1.txt -k lozinka18 -pbkdf2 -md md5
    openssl ${alg[i]} -d -in sifrat1.txt -salt -out sifrat2.txt -k lozinka3 -pbkdf2 -md md5
    openssl ${alg[i]} -d -in sifrat2.txt -salt -out sifrat3.txt -k lozinka30  -pbkdf2 -md md5
    echo "$(cat sifrat3.txt)"
done



