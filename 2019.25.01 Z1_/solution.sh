#!/bin/bash

#izlaz.enc je base64 kodovan, moramo da dekodujemo datoteku iz base64 formata
mv izlaz.enc izlaz.enc.base64
openssl enc -d -base64 -in izlaz.enc.base64 -out izlaz.enc

mkdir keys && mv *.key keys/

#Preimenujemo imena prvih 9 kljuceva, 01 u 1, 02 u 2...
for i in {1..9}; do
    mv keys/kljuc0$i.key keys/kljuc$i.key;
done

#Zbog asimetricne enkripcije, pronalazimo sve RSA kljuceve
#Napravimo folder dsa u kojem cemo smjestiti sve dsa kljuceve
mkdir keys/dsa
for i in {1..27}; do
    #uzima prvi red datoteke i gleda da li je prvi red DSA
    if [[ "$(cat keys/kljuc$i.key | awk 'NR==1')" =~ "DSA" ]];
    then
        mv keys/kljuc$i.key keys/dsa/kljuc$i,key;
    fi
done 2>/dev/null

#Kljucevi 18, 25 i 27 su base64 kodovani. Dekodujmo prve ta tri kljuca.
#Prodjemo kroz sve kjuceve i pokusamo da ih dekodujemo. Oni cije dekodovanje nije uspjesno ce biti prazni fajlovi, koje cemo ovom komandom obrisati. Dobili smo tri kljuca koji su u der formatu.

for i in {1..27}; do openssl enc -d -base64 -in keys/kljuc$i.key -out keys/kljuc$i.der; 
        #-s keys/kljuc$i.der provjerava postoji li datoteka i je li veća od nule bajtova.
        if [[ -s keys/kljuc$i.der ]]; 
            then rm keys/kljuc$i.key; 
            else rm keys/kljuc$i.der; 
        fi; 
done 2>/dev/null

#Preostali kjucevi su takodje u der formatu.
for i in {1..27}; do mv keys/kljuc$i.key keys/kljuc$i.der; done; 2>/dev/null
#Konvertujmo sve kljuceve u pem format.
for i in {1..27}; do openssl rsa -in keys/kljuc$i.der -inform DER -out keys/kljuc$i.pem -outform PEM && rm keys/kljuc$i.der || mv keys/kljuc$i.der keys/dsa/kljuc$i.der; done 2>/dev/null
#Sada su u folderu ostali samo rsa privatni kljucevi u pem formatu, a preostali dsa kljucevi u der formatu se prebaceni u dsa podfolder.

#Dekripcija izlaz.enc datoteke.
for i in {8..26}; do openssl rsautl -decrypt -in izlaz.enc -out ulaz$i.txt -inkey keys/kljuc$i.pem; done 2>/dev/null
for i in {8..26}; do openssl rsautl -decrypt -in izlaz.enc -out ulaz$i.txt -inkey keys/kljuc$i.pem; [[ -s ulaz$i.txt ]] || rm ulaz$i.txt; done 2>/dev/null
#Dobijamo samo jednu datoteku, ulaz18.txt koja je dobijena dekripcijom pomocu kljuc18.key kljuca.
#Sadrzaj datoteke je "Ulazna datoteka sadrzi smislen tekst."
