#!/bin/bash
mkdir {keys,signatures} && mv *.key keys/ && mv *.sign signatures/
#Svi potpisi su base64 kodovani, pa ih prvo dekodujemo.
for i in {1..31}; do openssl enc -d -base64 -in signatures/potpis$i.sign -out signatures/potpis$i.txt; done && rm signatures/*.sign
#Niti jedan od kljuceva nije base64, ali ima kombinacije RSA i DSA kljuceva, pri cemu se neki DSA kljucevi zasticeni lozinkom.
#Izbacimo listu dostupnih sha algoritama
openssl list --digest-commands | tr -s ' ' '\n' | grep -P "sha[\d-]*$" > sha.algos
#Razvrstajmo javne od privatnih kljuceva.
for i in {1..10}; do if [[ "$(cat keys/kljuc$i.key | awk 'NR==1')" =~ "PUBLIC" ]]; then mv keys/kljuc$i.key keys/public$i.pem; fi; done
#Potrebno je izbaciti javni kljuc iz ostalih privatnih kljuceva. For petlja ce ici od 1 do 10 ali cemo ignorisati eror koji ce se javiti kako kljuc 2 i 4 nisu dostupni.
#DSA kljuc 7 i 9 su zasticeni lozinkom. Prvo cemo da skinemo zastitu sa tih kljuceva.
openssl dsa -in keys/kljuc7.key -out keys/kljuc7.key -passin pass:sigurnost
openssl dsa -in keys/kljuc9.key -out keys/kljuc9.key -passin pass:sigurnost
#Kada budemo izvlacili javne kljuceve prvo cemo sve tretirati kao RSA, pa zatim sve kao DSA. Oni kljucevi koji ne budu odgovarali datom parametru funkcije nece biti uspjesno ekstraktovani, a eror poruku cemo ignorisati. Mogli smo prvo razvrstati kljuceve pa onda raditi ekstrakciju, ali je ovo brzi pristup.
for i in {1..10}; do openssl rsa -in keys/kljuc$i.key -pubout -out keys/public$i.pem; done 2>/dev/null
for i in {1..10}; do openssl dsa -in keys/kljuc$i.key -pubout -out keys/public$i.pem; done 2>/dev/null
#Napisimo skriput za provjeru potpisa.
touch script.sh && chmod +x script.sh
./script.sh 2>/dev/null
#Dobijemo ispis: "Solution: ulaz.txt + kljuc9 + sha1 algo = potpis21"
