#!/bin/bash

AWS_MASTER_ACCOUNT_ACCESS_KEY="xxx"
AWS_MASTER_ACCOUNT_SECRET_KEY="xxx"

openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private_key.pem -out public_key.pem

API_KEY_PUBLIC=$(cat public_key.pem)
API_KEY_PRIVATE=$(cat private_key.pem)

kubeseal --fetch-cert --controller-namespace sealed-secret > cert.pem

AWS_MASTER_ACCOUNT_ACCESS_KEY=$(echo -n "$AWS_MASTER_ACCOUNT_ACCESS_KEY" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-master --namespace kaytu-octopus)
AWS_MASTER_ACCOUNT_SECRET_KEY=$(echo -n "$AWS_MASTER_ACCOUNT_SECRET_KEY" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-master --namespace kaytu-octopus)
API_KEY_PUBLIC=$(echo -n "$API_KEY_PUBLIC" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-private --namespace kaytu-octopus)
API_KEY_PRIVATE=$(echo -n "$API_KEY_PRIVATE" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-private --namespace kaytu-octopus)

rm cert.pem private_key.pem public_key.pem

echo
echo "AWS_MASTER_ACCOUNT_ACCESS_KEY=$AWS_MASTER_ACCOUNT_ACCESS_KEY"
echo
echo "AWS_MASTER_ACCOUNT_SECRET_KEY=$AWS_MASTER_ACCOUNT_SECRET_KEY"
echo
echo "API_KEY_PUBLIC=$API_KEY_PUBLIC"
echo
echo "API_KEY_PRIVATE=$API_KEY_PRIVATE"
echo
