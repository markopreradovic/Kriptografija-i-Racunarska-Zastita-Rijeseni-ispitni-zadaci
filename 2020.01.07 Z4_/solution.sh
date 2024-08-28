#!/bin/bash
mkdir {potpisi,kljucevi} 
mv *.key kljucevi/ 
mv *.sign potpisi/

#Ekstraktujmo sve sha algoritme u jednu listu.
openssl list --digest-commands | tr -s " " "\n" | grep -E "^sha[0-9]+" > sha.algos

#Dekodujmo potpise iz base64 formata.
for i in {1..31}; do 
    openssl enc -d -base64 -in potpisi/potpis$i.sign -out potpisi/potpis$i.txt; 
done

#Provjerimo kakve sve kljuceve imamo. Nakon njihovog otvaranja, svi su citljivi, pa to znaci da svi u PEM formatu. Imamo mix RSA i DSA kljuceva. Trebamo ih odvojiti.
mkdir kljucevi/{rsa,dsa}
for i in {1..25}; do 
    TEXT=$(cat kljucevi/kljuc$i.key | awk 'NR==1'); 
    if [[ "$TEXT" =~ "RSA" ]]; then mv kljucevi/kljuc$i.key kljucevi/rsa/kljuc$i.key; 
    else mv kljucevi/kljuc$i.key kljucevi/dsa/kljuc$i.key; 
    fi; 
done 2>/dev/null 

#Sada izdvojimo javne kljuceve koje cemo koristiti za provjeru potpisa.
for i in {1..25}; do openssl rsa -in kljucevi/rsa/kljuc$i.key -pubout -out kljucevi/public$i.key; done 2>/dev/null
for i in {1..25}; do openssl dsa -in kljucevi/dsa/kljuc$i.key -pubout -out kljucevi/public$i.key; done 2>/dev/null 
# Napomena: kljuc 19 je kriptovan. Kako je on jedini takav pretpostavimo da je on rjesenje zadatka. Provjerimo nasu pretpostavku i samim tim skratimo vrijeme potrebno da se uradi zadatak.
#Napisimo skriptu.
while IFS= read -r sha
do
    for i in {1..31}
        do 
            VER=$(openssl dgst -$sha -verify kljucevi/public19.key -signature potpisi/potpis$i.txt ulaz.txt)
            if [[ "$VER" =~ "OK" ]]
            then
                echo "Solution is : kljuc19.key + $sha = potpis$i.txt"
                break 2
            fi
    done
done < sha.algos
#Dobijamo "Solution is : kljuc19.key + sha1 = potpis11.txt". Dobro smo pretpostavili, zaista se koristi kljuc 19 u kombinaciji sa sha1 algoritmom za potpis ulazne datoteke.
