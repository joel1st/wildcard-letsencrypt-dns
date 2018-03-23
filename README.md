**Generate SSL wildcard certs for any domain in route 53.**
Handles DNS entries in Route 53 + lets encrypt to generate wild card certs.

Example usage: 
`DOMAIN=example.com EMAIL=test@gmail.com BUCKET=examplesslcerts ./generate.sh`

Required env vars:
`DOMAIN` - Domain that the wild card cert will be generated for.
`EMAIL` - Email provided to lets encrypt.

Optional env vars:
`BUCKET` - name of the s3 bucket to save certs to.

Required:
- Docker
- AWS credentials (in standard `~/.aws/credentials` file - required for route 53 + optional bucket upload)
- AWS CLI (if uploading to the bucket)


Generated Files:
Your certs are generated into a folder named `ssl_out` in the directory the script is run from.  You'll typically use fullchain and privkey.

Notes: 
This is pretty much just a wrapper around the official dns-route53 certbot docker image.
https://hub.docker.com/r/certbot/dns-route53/
