mkdir {certs,newcerts,private,crl,requests}
touch index.txt crlnumber
echo 01 > serial

#Podesimo openssl.cnf datoteku
#Napravimo kljuc za ca sertifikat (s.cer)
openssl genrsa -out private/private.key 2048
openssl req -new -x509 -key private/private.key -out s.cer -config openssl.cnf

#Pravimo klijentske sertifikate
for i in {1..2}; do
    openssl genrsa -out private/key$i.pem 2048; 
done

for i in {1..2}; do
    openssl req -new -out requests/req$i.csr -key private/key$i.pem -config openssl.cnf;
done

openssl ca -in requests/req$i.csr -out certs/k1.cer -config openssl.cnf 
echo 04 > serial
openssl ca -in requests/req$i.csr -out certs/k1.cer -config openssl.cnf

mkdir solution
#Kreirajmo jks za serversku autentikaciju
openssl pkcs12 -export -out solution/server.p12 -inkey private/private.key -in s.cer

#Napravimo dvije pkcs12 datoteke iz klijentskih sertifikata
openssl pkcs12 -export -out solution/client1.p12 -inkey private/key1.pem -in certs/k1.cer -certfile s.cer
openssl pkcs12 -export -out solution/client2.p12 -inkey private/ket2.pem -in certs/k2.cer -certfile s.cer

#Podesimo server.xml datoteku
#KONVERTUJEMO SVE P12 DATOTEKE U JKS
