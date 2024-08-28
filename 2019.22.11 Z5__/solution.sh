#!/bin/bash

openssl enc -base64 -d -in izlaz.enc -out izlaz.dec
kljucevi=`ls | grep kljuc`

for kljuc in $kljucevi
do
	openssl enc -base64 -d -in $kljuc -out $kljuc.dec 2>error.txt
done

kljucevi2=`ls | grep kljuc`
for kljuc2 in $kljucevi2
do
	openssl rsa -in s$kljuc2 -inform DER -out $kljuc2.pem -outform PEM 2>error.txt
done

kljucevi3=`ls | grep kljuc`
for kljuc3 in $kljucevi3
do
	rhs=`openssl rsautl -decrypt -in izlaz.dec -inkey $kljuc3 2>error.txt`
	if [ "$rhs" != "" ]
	then
		echo $kljuc3
	fi
done


