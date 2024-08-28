#!/bin/bash
for i in {1..50}; do
    openssl enc -d -base64 -in ulaz$i.txt -out bulaz$i.txt
done

for i in {1..50}; do
    pas1=`openssl passwd -apr1 -salt ETF "ulaz$i.txt"`
    pas2=`openssl passwd -1 -salt ETF "ulaz$i.txt"`
    pas3=`openssl passwd -salt ETF "ulaz$i.txt"`
    if [[ "$pas1" == "$(cat bulaz$i.txt)" ]]; then
        echo "datoteka ulaz$i.txt algoritam apr1"
        break 
    fi

    if [[ "$pas2" == "$(cat bulaz$i.txt)" ]]; then
        echo "datoteka ulaz$i.txt algoritam 1"
        break 
    fi

    if [[ "$pas3" == "$(cat bulaz$i.txt)" ]]; then
        echo "datoteka ulaz$i.txt algoritam crypt"
        break 
    fi
done
