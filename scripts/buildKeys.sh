#!/bin/bash

if [ ! -f s3.conf ]; then
  echo "no s3.conf found, see README.MD, exiting" && exit 0
fi

export S3TEST_CONF=s3.conf
export AWS_SHARED_CREDENTIALS_FILE=credentials

#Build key files from s3.conf
access_key=$(grep -m 1 "access_key" s3.conf | sed 's/ //g')
secret_key=$(grep -m 1 "secret_key" s3.conf | sed 's/ //g')

touch credentials
credentials_access_key=$(echo "$access_key" | sed "s/access_key/aws_access_key_id/")
credentials_secret_key=$(echo "$secret_key" | sed "s/secret_key/aws_secret_access_key/")
echo "[default]" > credentials
echo "$credentials_access_key" >> credentials
echo "$credentials_secret_key" >> credentials
if [ ! -f credentials ]; then
  echo "credentials build error, exiting" && exit 0
fi

touch cleanupKeys
cleanup_access_key=$(echo "$access_key" | sed "s/access_key/id/")
cleanup_secret_key=$(echo "$secret_key" | sed "s/secret_key/key/")
echo "$cleanup_access_key" > cleanupKeys
echo "$cleanup_secret_key" >> cleanupKeys
if [ ! -f cleanupKeys ]; then
  echo "cleanupKeys build error, exiting" && exit 0
fi

#s3cmd uses white-spaces, re-using vars
access_key=$(grep -m 1 "access_key" s3.conf)
secret_key=$(grep -m 1 "secret_key" s3.conf)
host_base=$(grep -m 1 "host" s3.conf | sed "s/host/host_base/")

touch ~/.s3cfg
sed -i "s/access_key =.*/$access_key/" ~/.s3cfg
sed -i "s/secret_key =.*/$secret_key/" ~/.s3cfg
sed -i "s/host_base =.*/$host_base/" ~/.s3cfg

if grep -q "is_secure = false" "$S3TEST_CONF"; then
  sed -i "s/use_https =.*/use_https = False/" ~/.s3cfg
  else
  sed -i "s/use_https =.*/use_https = True/" ~/.s3cfg
fi

if [ ! -f ~/.s3cfg ]; then
	echo -en "s3cmd build error, exiting" && exit 0
fi

dos2unix credentials cleanupKeys ~/.s3cfg ~/.aws/credentials

#Remove ^M endings
#sed -i "s/\r//g" ~/.s3cfg
#sed -i "s/\r//g" credentials
#sed -i "s/\r//g" cleanupKeys

if [ -f ~/.s3cfg ]; then
  echo -en "$HOME/.s3cfg build complete\n"
fi

if [ -f credentials ]; then
  echo -en "credentials build complete\n"
fi

if [ -f cleanupKeys ]; then
  echo -en "cleanupKeys build complete\n"
fi

exit 0
