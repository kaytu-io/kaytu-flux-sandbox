#!/bin/bash

AWS_MASTER_ACCOUNT_ACCESS_KEY="xxx"
AWS_MASTER_ACCOUNT_SECRET_KEY="xxx"

kubeseal --fetch-cert --controller-namespace sealed-secret > cert.pem

AWS_MASTER_ACCOUNT_ACCESS_KEY=$(echo -n "$AWS_MASTER_ACCOUNT_ACCESS_KEY" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-master --namespace kaytu-octopus)
AWS_MASTER_ACCOUNT_SECRET_KEY=$(echo -n "$AWS_MASTER_ACCOUNT_SECRET_KEY" | kubeseal --cert cert.pem --from-file=/dev/stdin --raw --name kaytu-master --namespace kaytu-octopus)

rm cert.pem

echo "AWS_MASTER_ACCOUNT_ACCESS_KEY=$AWS_MASTER_ACCOUNT_ACCESS_KEY"
echo "AWS_MASTER_ACCOUNT_SECRET_KEY=$AWS_MASTER_ACCOUNT_SECRET_KEY"