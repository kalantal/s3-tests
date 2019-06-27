#!/bin/bash

if [ ! -f s3.conf ]; then
	echo "no s3.conf found, see README.MD, exiting" && exit 0
fi

export S3TEST_CONF=s3.conf
export BOTO_CONFIG=boto.ini
export AWS_SHARED_CREDENTIALS_FILE=credentials

#Build key files from s3.conf
access_key=$(grep -m 1 "access_key" s3.conf | sed 's/ //g')
secret_key=$(grep -m 1 "secret_key" s3.conf | sed 's/ //g')

touch credentials
credentials_access_key=$(echo "$access_key" | sed "s/access_key/aws_access_key_id/")
credentials_secret_key=$(echo "$secret_key" | sed "s/secret_key/aws_secret_access_key/")
echo "[default]" > credentials
echo $credentials_access_key >> credentials
echo $credentials_secret_key >> credentials
if [ ! -f credentials ]; then
	echo "credentials build error, exiting" && exit 0
fi

touch cleanupKeys
cleanup_access_key=$(echo "$access_key" | sed "s/access_key/id/")
cleanup_secret_key=$(echo "$secret_key" | sed "s/secret_key/key/")
echo $cleanup_access_key > cleanupKeys
echo $cleanup_secret_key >> cleanupKeys
if [ ! -f cleanupKeys ]; then
	echo "cleanupKeys build error, exiting" && exit 0
fi

#s3cmd uses white-spaces, re-using vars
access_key=$(grep -m 1 "access_key" s3.conf)
secret_key=$(grep -m 1 "secret_key" s3.conf)
host_base=$(grep -m 1 "host" s3.conf | sed "s/host/host_base/")

touch ~/.s3cfg
sed -i "s/access_key =.*/$access_key/" ~/.s3cfg
sed -i "s/secret_key =.*/$secret_key/" cleanupKeys
sed -i "s/host_base =.*/$host_base/" credentials

if grep -q "is_secure = false" "$S3TEST_CONF"; then
  sed -i "s/use_https =.*/use_https = False/" ~/.s3cfg
  else
  sed -i "s/use_https =.*/use_https = True/" ~/.s3cfg
fi

if [ ! -f ~/.s3cfg ]; then
	echo "s3cmd build error, exiting" && exit 0
fi

#Remove ^M endings
sed -i "s/\r//g" ~/.s3cfg
sed -i "s/\r//g" credentials
sed -i "s/\r//g" cleanupKeys

DATE=$(date +%Y-%m-%d_%H%M)
LOG_DIR=output/$DATE
mkdir -p $LOG_DIR
test_cmd="S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --xunit-file=$LOG_DIR/nosetests.xml --with-blacklist --blacklist-file=blacklists/blacklist.txt"

(
  echo "COMMAND: $test_cmd"
  echo
  echo "ENVIRONMENT:"
  echo "======================================================================"
  env | grep S3
  env | grep boto
  echo "======================================================================"
  echo
  echo "CONFIG:"
  echo "======================================================================"
  echo "S3TEST_CONF"
  cat $S3TEST_CONF
  echo
  echo "BOTO_CONFIG"
  cat $BOTO_CONFIG
  echo
  echo "credentials"
  cat credentials
  echo
  echo "cleanupKeys"
  cat cleanupKeys
  echo
  echo "======================================================================"
  echo
) > $LOG_DIR/output.log

eval $test_cmd 2>&1 | tee -a $LOG_DIR/output.log

perl scripts/parse-nose.pl -i $LOG_DIR/nosetests.xml -o $LOG_DIR/nosetests.csv
sed -ri '/teardown/d' $LOG_DIR/nosetests.csv

# Cleanup
bash scripts/s3deletebuckets.sh 2>&1 | tee -a $LOG_DIR/output.log
bash scripts/s3wipe.sh 2>&1 | tee -a $LOG_DIR/output.log
echo -en '\nRemaining Vaults:\n' | tee -a $LOG_DIR/output.log
s3cmd ls | awk '{print $3}' | grep $prefix 2>&1 | tee -a $LOG_DIR/output.log
