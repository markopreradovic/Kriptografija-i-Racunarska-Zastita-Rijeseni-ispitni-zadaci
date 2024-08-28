#!/bin/bash
mkdir {keys,signatures}
mv *.key keys/
mv potpis* signatures/

mv keys/key73_.key keys/key73.key

openssl list --digest-commands | tr -s " " "\n" | grep -E "sha[0-9]+" > sha.algos

#Za smjestanje razlicitih kljuceva
mkdir keys/{public,rsa,dsa}
for i in {1..80}
do
    KEY=$(cat keys/key$i.key | awk 'NR==1')
    if [[ "$KEY" =~ "PUBLIC" ]]
    then
        mv keys/key$i.key keys/public/keys$i.key
    elif [[ "$KEY" =~ "RSA" ]]
    then
        mv keys/key$i.key keys/rsa/keys$i.key
    elif [[ "$KEY" =~ "DSA" ]]
    then
        mv keys/key$i.key keys/dsa/keys$i.key
    fi
done

#Dekodovanje potpisa
mkdir signatures/decoded
for i in {1..32}; do
    openssl enc -d -base64 -in signatures/potpis$i.sign -out signatures/decoded/potpis$i.sign;
done

#Svi kljucevi su PEM
#Izdvojimo public kljuceve 
for i in {1..33}; do
    openssl rsa -in keys/rsa/keys$i.key -inform PEM -pubout -out keys/public/keys$i.key; 
done 2>/dev/null

for i in {42..78}; do
    openssl dsa -in keys/dsa/keys$i.key -inform PEM -pubout -out keys/public/keys$i.key;
done 2>/dev/null

while IFS= read -r sha #sha algo loop
do
    for i in {1..80} #key loop
    do
        for j in {1..32} #signature loop
        do
            RES=$(openssl dgst -$sha -verify keys/public/keys$i.key -signature signatures/decoded/potpis$j.sign ulaz.txt)
            if [[ "$RES" =~ "OK" ]]
            then
                echo "Solution: Key$i + $sha + ulaz.txt= potpis$j.sign"
                break 3
            fi
        done
    done
done < sha.algos
#Dobijemo sljedece -> Solution: Key70 + ulaz.txt = potpis23.sign
#Rjesenje je potpis 23.
