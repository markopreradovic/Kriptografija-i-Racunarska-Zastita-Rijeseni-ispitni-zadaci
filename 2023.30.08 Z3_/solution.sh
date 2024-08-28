#!/bin/bash
openssl enc -in sifrat.txt -out bsifrat.txt -base64 -d 

for i in {1..3}; do
    openssl enc -d -base64 -in otisak$i.txt -out botisak$i.txt
done

for i in {1..30}; do
    pas1=`openssl passwd -apr1 -salt lozinka1 "$(cat lozinka$i.txt)"`
    pas2=`openssl passwd -apr1 -salt lozinka7 "$(cat lozinka$i.txt)"`
    pas3=`openssl passwd -apr1 -salt wAgnh5WA "$(cat lozinka$i.txt)"`
    if [[ "$pas1" == "$(cat botisak1.txt)" ]]; then
        echo "kljuc1"
        echo "lozinka$i"
    fi
    if [[ "$pas2" == "$(cat botisak2.txt)" ]]; then
        echo "kljuc2"
        echo "lozinka$i"
    fi
    if [[ "$pas3" == "$(cat botisak3.txt)" ]]; then
        echo "kljuc3"
        echo "lozinka$i"
    fi
done

#kljuc2
#lozinka3
#kljuc1
#lozinka18
#kljuc3
#lozinka30
#Rjesenja 1-18 2-3 3-30

tekst="aes-256-cbc       aes-256-ecb"
algoritmi="$tekst"
for algo in $algoritmi; do
    echo "$algo"
    openssl $algo -in bsifrat.txt -out sifrat1.dec -d -k "lozinka30" 2>error.txt
    openssl $algo -in sifrat1.dec -out sifrat2.dec -d -k "lozinka3" 2>error.txt
    openssl $algo -in sifrat2.dec -out sifrat3.dec -d -k "lozinka18" 2>error.txt
    cat sifrat3.dec
done


