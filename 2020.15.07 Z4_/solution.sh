#!/bin/bash
mkdir {otisci,ulazi}
mv otisak*.txt otisci/
mv ulaz*.txt ulazi/

openssl list --digest-commands | tr -s " " "\n" > digest.list

#Otisci 2 i 3 su base64 kodovani. Dekodujmo ih.
for i in {2..3}; do mv otisci/otisak$i.txt otisci/otisak$i.base64; done
for i in {2..3}; do openssl enc -d -base64 -in otisci/otisak$i.base64 -out otisci/otisak$i.txt; done

while IFS= read -r algo
do
    for i in {1..50}
    do
        openssl dgst -$algo -out otisak.txt ulazi/ulaz$i.txt
        for j in {1..4} 
        do
            if [[ "$(cat otisak.txt)" =~ "$(cat otisci/otisak$j.txt)" ]]
            then
                echo "ulaz$i.txt + $algo = otisak$j.txt"
                break
            fi
        done
    done
done < digest.list 2>/dev/null
#ulaz13.txt + md5 = otisak2.txt
#ulaz44.txt + sha224 = otisak3.txt
#ulaz6.txt + sha512 = otisak4.txt

