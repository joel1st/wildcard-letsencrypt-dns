# **Generate SSL wildcard certs for any domain in route 53.**
Handles DNS entries in Route 53 + lets encrypt to generate wild card certs.

## Example usage: 
`DOMAIN=example.com EMAIL=test@gmail.com BUCKET=examplesslcerts ./generate.sh`

## Required env vars:
- `DOMAIN` - Domain that the wild card cert will be generated for.
- `EMAIL` - Email provided to lets encrypt.

## Optional env vars:
- `BUCKET` - name of the s3 bucket to save certs to.

## Dependencies:
- Docker
- AWS credentials (in standard `~/.aws/credentials` file - required for route 53 + optional bucket upload)
- AWS CLI (if uploading to the bucket)

## Generated Files:
Your certs are generated into a folder named `ssl_out` in the directory the script is run from.  You'll typically use fullchain and privkey.

If you save these files to an s3 bucket (using the BUCKET env var), you can access it anywhere with: 
`aws s3 cp s3://$BUCKET/$DOMAIN/fullchain1.pem .`

## Automation of cert generation:
Because the script is not interactive, this is super easy to automate. Just set it up to run on a cron (every few weeks). The certs are then automatically pushed to s3. Pull the certs from s3 on a cron or startup to the services that require it. 

###Notes: 
This is pretty much just a wrapper around the official dns-route53 certbot docker image.
https://hub.docker.com/r/certbot/dns-route53/
