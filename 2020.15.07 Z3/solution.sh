#!/bin/bash
mkdir lozinke
mv lozinka*.txt lozinke/

mkdir potpisi
mv potpis*.txt potpisi/

mv sifra.txt sifrat.base64
openssl enc -d -base64 -in sifrat.base64 -out sifrat.txt

