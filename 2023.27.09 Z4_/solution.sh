#!/bin/bash
certs="cert*"
crls="crl*"

for cert in $certs
do
	serial=`openssl x509 -in $cert -serial -noout | sed s/serial=//`

	for crl in $crls
	do
		lista=`openssl crl -in $crl -noout -text`
        echo "$serial"
		if [[ "$lista" =~ "$serial" ]]; then
			echo $cert
			break
		fi
	done
done
