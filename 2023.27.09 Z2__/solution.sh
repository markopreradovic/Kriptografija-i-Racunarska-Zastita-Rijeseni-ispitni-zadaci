#!/bin/bash
openssl enc -d -base64 -in sifrat.txt -out sifrat.dec
ulazi="ulaz*"

for ulaz in $ulazi
do
	sadrzaj=`cat $ulaz`
	key=`openssl passwd -5 -salt $sadrzaj $ulaz`
	text=`openssl enc -aria-192-ofb -d -nosalt -in sifrat.dec -k $key -out dec$ulaz.dec 2>error.txt`
done

dec="*.dec"

for f in $dec
do
	echo "$(cat $f)"
    echo "/n"
done
