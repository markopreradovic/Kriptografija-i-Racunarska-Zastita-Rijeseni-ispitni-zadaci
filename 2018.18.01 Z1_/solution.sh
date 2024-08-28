#!/bin/bash

i=1

#Smjestamo sve algoritme
tekst="sha1              sha224            
sha256            sha3-224          sha3-256          sha3-384          
sha3-512          sha384            sha512            sha512-224        
sha512-256"
algoritmi=(${tekst})

potpis=`openssl enc -base64 -d -in otisak.hash`

while [ $i -lt 101 ]; do
    j=0
    while [ $j -lt 101 ]; do
        #Izdvajamo drugi dio teksta:
        #-d je delimiter, ' ' odvaja, f2 znaci drugi dio
        hes=`openssl dgst -${algoritmi[$j]} izlaz$i.crypt | cut -d ' ' -f2`
    
        if [ "$potpis" = "$hes" ]; then

            echo "izlaz$i.crypt"
            echo `cat izlaz$i.crypt`
            datoteka = "izlaz$i.crypt"
            `cat izlaz$i.crypt | cut -d '_' -f3 > datoteka.txt`
    
        fi
        ((j++))
     done
    ((i++))
done

`openssl aes-256-cbc -d in datoteka.txt -out tekst.txt -k sigurnost`
echo `cat tekst.txt`
echo `cat tekst`

#Rjesenje: izlaz71.crypt
        
    
