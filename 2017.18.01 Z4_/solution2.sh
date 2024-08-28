#!/bin/bash

niz=`ls | grep public`
niz2=`ls | grep potpis`

for potpis in $niz2
do
    openssl enc -base64 -d -in $potpis -out "d$potpis"
done

niz3=`ls | grep dpotpis`

for kljuc in $niz
do
    for dpotpis in $niz3
    do
        echo $kljuc
        echo $potpis
        openssl dgst -sha224 -verify $kljuc -signature $dpotpis ulaz.txt
    done
done

#Rj: kljuc5 potpis9
