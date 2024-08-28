#!/bin/bash
for i in {1..3}; do
    openssl enc -d -base64 -in otisak$i.txt -out botisak$i.txt
done
openssl enc -d -base64 -in sifrat.txt -out sifrat.dec

for i in {0..30}; do
    pas1=`openssl passwd -apr1 -salt lozinka1 lozinka$i`
    pas2=`openssl passwd -apr1 -salt lozinka7 lozinka$i`
    pas3=`openssl passwd -apr1 -salt wAgnh5WA lozinka$i`
    
    if [[ "$(cat botisak1.txt)" == "$pas1" ]]; then 
        echo "Kljuc1 - lozinka$i"
    fi

    if [[ "$(cat botisak2.txt)" == "$pas2" ]]; then 
        echo "Kljuc2 - lozinka$i"
    fi
    
    if [[ "$(cat botisak3.txt)" == "$pas3" ]]; then 
        echo "Kljuc3 - lozinka$i"
    fi
done

tekst="aes-256-cbc  aes-256-ecb"
algoritmi=$tekst
for algo in $algoritmi; do
    openssl $algo -d -in sifrat.dec -out sifrat2.dec -k "lozinka30" 2>error.txt
    openssl $algo -d -in sifrat2.dec -out sifrat3.dec -k "lozinka3" 2>error.txt
    openssl $algo -d -in sifrat3.dec -out sifrat4.dec -k "lozinka18" 2>error.txt
    cat sifrat4.dec
done
    
