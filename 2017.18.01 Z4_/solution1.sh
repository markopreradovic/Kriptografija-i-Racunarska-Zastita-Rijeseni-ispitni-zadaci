#!/bin/bash

niz=`ls | grep .key`
for kljuc in $niz
do
    openssl rsa -in $kljuc -inform PEM -out $kljuc.public -pubout
done
