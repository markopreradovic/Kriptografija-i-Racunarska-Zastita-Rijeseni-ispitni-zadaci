#!/bin/bash
mv kljuc.txt kljuc.base64
openssl enc -d -base64 -in kljuc.base64 -out kljuc.dec
openssl enc -d -base64 -in sifrat.txt -out sifrat.dec
#sifrat ima salt kada ga procitamo

#RUCNO SAM DODAO KLJUC
#Nakon provjere citanjem vidimo da je kljuc z04/client.key u DER formatu.
#"Kopirajmo" PEM format datog kljuca u folder 3. zadatka.
openssl rsa -in client.key -inform DER -outform PEM -out client.key 

#Sada trebamo dekriptovati kljuc.dec koristeci privatni kljuc client.key.
openssl pkeyutl -decrypt -in kljuc.dec -out kljuc.txt -inkey client.key
cat kljuc.txt
#PISE: neporecivost

mkdir ulaz
openssl enc -ciphers | sed "1d" | tr -s " " "\n" | cut -c2- | grep -E "^rc*" > rc.list
while IFS= read -r rc
do
    openssl $rc -d -in sifrat.dec -out ulaz/ulaz-$rc.txt -k neporecivost -pbkdf2
    echo -n "ulaz-$rc.txt - >" && cat ulaz/ulaz-$rc.txt && echo
done < rc.list
#Dobijemo da je odgovarajuci algoritam rc4-40 sa kojim dobijemo ulaznu datoteku sa sadrzajem "Rijesili ste zagonetku!"

