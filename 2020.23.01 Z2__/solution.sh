#!/bin/bash

#otisci.txt i izlaz.txt datoteke su base64 kodovane
mv izlaz.txt izlaz.base64
mv otisci.txt otisci.base64

#izlaz.txt sadrzi salt
openssl enc -d -base64 -in izlaz.base64 -out izlaz.txt
openssl enc -d -base64 -in otisci.base64 -out otisci.txt

#Odsjecamo nepotreban dio izmedju $ simobla koji pravi problem prilikom koristenja grep funkcije jer je $ posaban simbol. Alternativno smo mogli ubaciti escape karakter ispred $, tj. \$.
cat otisci.txt | cut -d'$' -f 4 > otisci_mod.txt

#Izdvojimo simetricne sifrate iz openssl-a
openssl enc -ciphers | sed "1d" | tr -s " " "\n" | cut -c2- > ciphers.list

touch script.sh && chmod +x script.sh
./script.sh

#Dobijamo izlaz:
#cast5-cfb -> $1$lozinka$M/0RP5YL8CBfA.SjHOi7t0
#aes-128-cbc -> $1$123456$ltK5iTsKccWvIvbP.5gad1
#des-ede -> $1$123456$31VBrlI9HM42p032CsLfg.
#rc4 -> $1$123456$st88JB7T9b6Inxq.FZgqz0
#rc2-ecb -> $1$123456$NmBjUMh9EjNoTZrjdme0U1
#bf-cbc -> $1$abcdefgh$lBTJFOrLvp0KPr7wMvGqO1
#rc2-ofb -> $1$abcdefgh$1pkKz9DR/bBFRSLtYGVf80
#des-ede3-cfb -> $1$abcdefgh$f1w3vrCCX3RzuEwPIJFsk0
#aes-256-ecb -> $1$abcdefgh$WxFmM2TPw9B6.FO0Ghzmq/
#Dva otiska nisu pronadjena!

#Takodje dobijamo datoteku algos.list u kojoj se nalaze samo imena algoritama sa kojima pokusavamo dekripciju.
touch script-dec.sh && chmod +x script-dec.sh
./script-dec.sh
#Rjesenje je dobijeno algoritmom rc2-ofb. Dekriptovana datoteka sadrzi poruku: "Uspjesno ste dekriptovali sifrat."
