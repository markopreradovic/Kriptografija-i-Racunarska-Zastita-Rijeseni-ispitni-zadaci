 #!/bin/bash
mkdir keys 
mv *.key keys/

#client.pem je u  PEM formatu. Svi kljucevi su RSA privatni kljucevi u PEM formatu
#Izdvojimo javni kljuc iz client.pem-a
openssl x509 -in client.pem -inform PEM -pubkey -noout client-pubkey.pem

for i in {1..100}; do
    openssl rsa -in keys/kljuc$i.key -pubout -out keys/public$i.pem;
    if [[ "$(diff keys/public$i.pem client-pubkey.pem])" == "" ]];
    then
        echo "MATCH: key$i";
        break;
    fi;
    rm keys/public$i.pem;
done 2>/dev/null

#MATCH key77
#Kreirajmo pkcs12 datoteku
openssl pkcs12 -export -out client.p12 -inkey keys/kljuc77.key -in client.pem
