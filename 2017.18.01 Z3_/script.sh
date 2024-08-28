#!/bin/bash

list="opis*"
openssl enc -base64 -d -in sifrat.txt -out sifrat.dec
for i in $list
do
    rez=`openssl passwd -apr1 -salt 5xYExKym $i`
    if [ "$rez" == "\$apr1\$5xYExKym\$Bkfh/waMOSHfYgY1SNY3j0" ]
    then
        echo $i
        break;
    fi
    
done
echo -e "Fajl je: $i"
echo -e "Sadrzaj fajla je: "
cat $i

openssl des-ofb -in sifrat.dec -out izlaz.txt -d -md md5 -k 6siglozinka 


#ovaj zadatak radi na drugoj verziji
#na novoj ne moze
