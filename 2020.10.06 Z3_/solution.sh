#/bin/bash
mkdir ulaz
mv ulaz*.txt ulaz/

#Otisak je base64
mv otisak.txt otisak.base64
openssl enc -d -base64 -in otisak.base64 -out otisak.txt

#Izdvajamo hash algoritme
openssl list --digest-commands | tr -s " " "\n" > hashalgo.list

otisak=$(cat otisak.txt)
while IFS= read -r algo
do
    for i in {1..50}
    do
        if [[ "$(openssl dgst -$algo ulaz/ulaz$i.txt)" =~ "$otisak" ]];
        then
                echo "MATCH: ulaz$i.txt + $algo = otisak.txt"
                break 2
        fi
    done
done < hashalgo.list

#MATCH: ulaz25.txt + sha384 = otisak.txt

