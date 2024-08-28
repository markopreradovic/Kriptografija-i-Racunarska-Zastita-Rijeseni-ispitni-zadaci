#!/bin/bash
mkdir keys 
cp *.key keys/

#cert.p12 je base64 kodovan
mv cert.p12 cert.p12.base64
openssl enc -d -base64 -in cert.p12.base64 -out cert.p12

#Kljucevi su u der formatu
for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.key -inform der -outform pem -out keys/key$i.pem;
done 2>/dev/null


#Imamo 10 kljuceva koji su base64 kodovani
for i in {10..100..10}; do
    mv keys/kljuc$i.key keys/kljuc$i.key.base64 
    openssl enc -d -base64 -in keys/kljuc$i.key.base64 -out keys/kljuc$i.key;
done;


for i in {10.100.10}; do
    openssl rsa -in keys/kljuc$i.key -inform der -outform pem -out keys/key$i.pem
    
done 2>/dev/null

#Svi kljucevi su RSA private
#Izbacimo javne kljuceve iz RSA privatnih
for i in {1..100}; do
    openssl rsa -in keys/key$i.pem -pubout -out keys/public$i.pem;
done;



#Izbacimo sertifikate iz .p12 datoteke
openssl pkcs12 -in cert.p12 -nokeys -cacerts -out s2.pem -passing pass:sigurnost
openssl pkcs12 -in cert.p12 -nocerts -out prvi.key -passin pass:sigurnost

#Izdvojimo javne kljuceve
openssl x509 -in s1.pem -pubkey -noout > s1.public
openssl x509 -in s2.pem -pubkey -noout > s2.public

#Pronalazimo match
for i in {1..100}; do
    for j in {1..2}; do
        if [[ "$(diff keys/public$i.pem s$j.public | awk 'NR==1')" == "" ]]; then
            echo "MATCH: key$i" && mv keys/public$i.pem . && break 2;
        fi;
    done;
done;
#MATCH key70
#Kreirajmo digitalnu envelopu od .p12 datoteke tako sto cemo da je enkriptujemo koristeci javni RSA kljuc 70.
#openssl rsautl -encrypt -in cert.p12 -out cert.env -inkey public70.pem -pubin 
#Enkripcija nije prosla zato sto je .p12 datoteka prevelika da bi se enkriptovala sa kljucem 70.
