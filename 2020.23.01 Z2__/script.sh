#!/bin/bash
while IFS= read -r cipher
do
    echo "$cipher -> $(openssl passwd -salt lozinka -1 $cipher)" >> svi-otisci.txt
    echo "$cipher -> $(openssl passwd -salt 123456 -1 $cipher)" >> svi-otisci.txt
    echo "$cipher -> $(openssl passwd -salt abcdefgh -1 $cipher)" >> svi-otisci.txt
done < ciphers.list

while IFS= read -r otisak
do
    res=$(grep -E "*$otisak*" svi-otisci.txt)
    if [[ "$res" != "" ]]
    then
        echo "$res" | cut -d' ' -f 1 >> algos.list
        echo "$res"
    fi
done < otisci_mod.txt

rm svi-otisci.txt
