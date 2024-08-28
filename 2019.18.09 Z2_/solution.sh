#U pratećim materijalima je data datoteka sa šifratom dobijenim kriptovanjem nepoznate ulazne datoteke AES-128 algoritmom dva puta. U pratećim materijalima su date i datoteke sa ključevima, pri čemu je isti ključ korišten za oba kriptovanja. Odrediti koji ključ je korišten za enkripcije i izvršiti potrebne dekripcije. Ulazna datoteka sadrži smislen tekst.
#!/bin/bash

# Dekodirajte šifrat iz Base64 formata
openssl enc -d -base64 -in sifrat.txt -out sifrat.dec

# Definišemo algoritme
algoritmi="aes-128-cbc aes-128-ecb"

# Istražujemo sve moguće ključeve i algoritme
for i in {0..20}; do
    for alg in $algoritmi; do
        # Učitavamo ključ iz datoteke
        kljuc=$(cat lozinka$i.txt) # Uklanja dodatne bele prostore

        # Prvi pokušaj dekripcije
        if openssl enc -$alg -d -in sifrat.dec -out sifrat-novi.dec -k $kljuc -md md5; then
            # Drugi pokušaj dekripcije
            if openssl enc -$alg -d -in sifrat-novi.dec -out rezultat.dec -k $kljuc -md md5; then
                
                    echo "Ključ pronađen u lozinka$i.txt"
                    echo "Korišćen algoritam: $alg"
                    echo "Sadržaj:"
                    cat rezultat.dec
                    exit 0
                
            fi
        fi
    done
done
