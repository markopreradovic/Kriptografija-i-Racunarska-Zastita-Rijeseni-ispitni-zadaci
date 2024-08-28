#!/bin/bash
mkdir sifrati 
mv sifrat*.txt sifrati/

#otisak.hash je base64 kodovan.
mv otisak.hash otisak.hash.base64
openssl enc -d -base64 -in otisak.hash.base64 -out otisak.hash
rm otisak.hash.base64

#Sifrati su svi base64 kodovani.
for i in {1..251}; do 
    mv sifrati/sifrat$i.txt sifrati/sifrat$i.txt.base64; 
    openssl enc -d -base64 -in sifrati/sifrat$i.txt.base64 -out sifrati/sifrat$i.txt; 
done; 
rm sifrati/*.base64 2>/dev/null

#Dekriptujmo sifrate.
mkdir ulazi
for i in {1..251}; do 
    openssl aes-192-cbc -d -in sifrati/sifrat$i.txt -out ulazi/ulaz$i.txt -k sigurnost; 
done 2>/dev/null

#Izdvojimo dostupne hashing algoritme.
openssl list --digest-commands | tr -s " " "\n" > dgst.algos
#Nadjimo match.
for i in {1..252}; do 
    while IFS= read -r hasher; do 
        if [[ "$(openssl dgst -$hasher ulazi/ulaz$i.txt)" =~ "$(cat otisak.hash)" ]]; then 
            echo "MATCH: ulaz$i"; 
            break 2; 
        fi; 
    done < dgst.algos; 
done 2>/dev/null
#Dobijamo "MATCH: ulaz251".

