#!/bin/bash
for i in {1..20}; do
    openssl enc -d -base64 -in potpis$i.sign -out bpotpis$i.sign
done

for i in {1..70}; do
    for j in {1..20}; do
        potpis=`openssl dgst -sha1 -verify key$i.key -signature bpotpis$j.sign ulaz.txt 2>error.txt`
        if [[ "$potpis" =~ "OK" ]]; then
            echo "key$i + potpis$j"
            break 2
        fi
        potpis2=`openssl dgst -sha1 -prverify key$i.key -signature bpotpis$j.sign ulaz.txt 2>error.txt`
        if [[ "$potpis2" =~ "OK" ]]; then
            echo "key$i + potpis$j"
            break 2
        fi
        
    done
done

#key65 + potpis13

