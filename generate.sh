#!/bin/bash
rm -rf ssl_out
mkdir ssl_out

docker run -it --rm --name certbot \
  -v "`echo ~/.aws`:/root/.aws" \
  -v "`pwd`/ssl_out:/etc/letsencrypt/archive/" \
  --env AWS_PROFILE=${AWS_PROFILE-default} \
  certbot/dns-route53 certonly \
  -n --email $EMAIL \
  --agree-tos --preferred-challenges dns \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --dns-route53 --dns-route53-propagation-seconds 60 \
  -d $DOMAIN -d "*.$DOMAIN"

cd ssl_out/$DOMAIN/
mv fullchain1.pem fullchain.pem
mv privkey1.pem privkey.pem
mv cert1.pem cert.pem
mv chain1.pem chain.pem
cd ../../

if [[ $BUCKET ]]; then
  aws s3 mb s3://$BUCKET
  aws s3 sync ssl_out s3://$BUCKET/
fi
