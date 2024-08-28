#!/bin/bash
openssl enc -d -base64 -in otisci.txt -out botisci.txt
tekst="1    5   apr1    6"
tekstsalt="________   ulaz10.txt   ........   iLvmf9BFebiWZ1kW   8765432112345678"
algoritmi=$tekst
salts=$tekstsalt

while IFS= read -r otisak; do

    for algo in $algoritmi; do
        for salt in $salts; do
            for i in {1..50}; do            
                    otisak2=`openssl passwd -$algo -salt $salt ulaz$i`
                    if [[ "$otisak" == "$otisak2" ]]; then
                        echo "Algoritam: $algo"
                        echo "Otisak: $otisak2"
                        echo "Poklapanje: $otisak"
                        echo "Datoteka: ulaz$i.txt"
                        echo "//////"
                    fi
            done
        done    
    done

done < botisci.txt
#Rjesenje 14 22 40 41
