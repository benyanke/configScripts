#!/bin/bash

## Add heading here





# Settings
email="benyanke@gmail.com"
root="/var/www/.letsencrypt/public_html/"

# If set to 1, all domains are issued on a single cert
# If set to 0, each individual domain is issued it's own cert
singleCert="1"

# Check for root
# TODO


# check if certbot is installed
# TODO

# Parse command line domains into format usable by certbot
# Then get certs

domainList=""
for var in "$@"; do

  if [[ $singleCert = 0 ]] ; then
    sudo certbot certonly \
      --webroot \
      --no-eff-email \
      --agree-tos \
      --email=$email \
      --webroot-path=$root \
      -d $var
  else
    domainList="$domainList -d $var "
  fi

done



if [[ $singleCert = 1 ]] ; then
  sudo certbot certonly \
    --webroot \
    --no-eff-email \
    --agree-tos \
    --email=$email \
    --webroot-path=$root \
    $domainList
fi
