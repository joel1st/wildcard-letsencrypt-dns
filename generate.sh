#!/bin/bash

DATE_STRING=`date +"%Y-%m-%d_%H-%M-%S"`

mkdir `echo $DATE_STRING`

docker run -it --rm --name certbot \
  -v "`echo ~/.aws`:/root/.aws" \
  -v "`pwd`/$DATE_STRING:/etc/letsencrypt/archive/" \
  --env AWS_PROFILE=${AWS_PROFILE-default} \
  certbot/dns-route53:v0.28.0 certonly \
  -n --email $EMAIL \
  --agree-tos --preferred-challenges dns \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --dns-route53 --dns-route53-propagation-seconds 60 \
  -d $DOMAIN -d "*.$DOMAIN"



if [[ $BUCKET ]]; then
  aws s3 mb s3://$BUCKET
  aws s3 sync `echo $DATE_STRING` s3://$BUCKET/
  
  aws s3 mv s3://$BUCKET/$DOMAIN/fullchain1.pem s3://$BUCKET/$DOMAIN/fullchain.pem
  aws s3 mv s3://$BUCKET/$DOMAIN/privkey1.pem s3://$BUCKET/$DOMAIN/privkey.pem
  aws s3 mv s3://$BUCKET/$DOMAIN/cert1.pem s3://$BUCKET/$DOMAIN/cert.pem
  aws s3 mv s3://$BUCKET/$DOMAIN/chain1.pem s3://$BUCKET/$DOMAIN/chain.pem
fi
