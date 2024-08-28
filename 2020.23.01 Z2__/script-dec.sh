#!/bin/bash
while IFS= read -r algo
do
    openssl $algo  -d -in izlaz.txt -out ulaz.txt -k $algo
    echo "algo -> $(cat ulaz.txt)"
    rm ulaz.txt
done < algos.list
