#!/bin/bash

mkdir {certs,newcerts,crl,private,requests}
touch index.txt crlnumber
echo 01>serial
