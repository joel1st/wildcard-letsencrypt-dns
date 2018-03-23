#!/bin/bash
rm -rf ssl_out

docker run -it --name certbot -v "`echo ~/.aws`:/root/.aws" -v "`pwd`/ssl_out:/etc/letsencrypt/archive/" certbot/dns-route53 certonly -n --email $EMAIL --agree-tos --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory --dns-route53 --dns-route53-propagation-seconds 60 -d $DOMAIN -d "*.$DOMAIN"

if [[ $BUCKET ]]; then
  aws s3 mb s3://$BUCKET
  aws s3 sync ssl_out s3://$BUCKET/
fi
