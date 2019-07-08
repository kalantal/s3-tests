#!/bin/bash

if [ ! -d "virtualenv" ]; then
  echo -en "Setting up enviornment:\n"
  bash bootstrap
fi

if [ ! -f s3.conf ]; then
  echo "no s3.conf found, see README.MD, exiting" && exit 0
fi

export S3TEST_CONF=s3.conf
#export BOTO_CONFIG=boto.ini
#export AWS_SHARED_CREDENTIALS_FILE=credentials
export prefix=s3tests-
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt

bash scripts/buildKeys.sh &> /dev/null

DATE=$(date +%Y-%m-%d_%H%M)
LOG_DIR=output/$DATE
mkdir -p "$LOG_DIR"
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
  #echo "BOTO_CONFIG"
  #cat $BOTO_CONFIG
  echo
  echo "credentials"
  cat credentials
  echo
  echo "cleanupKeys"
  cat cleanupKeys
  echo
  echo "======================================================================"
  echo
) > "$LOG_DIR"/output.log

echo -en "s3-tests:\n"
eval "$test_cmd" 2>&1 | tee -a "$LOG_DIR"/output.log

perl scripts/parse-nose.pl -i "$LOG_DIR"/nosetests.xml -o "$LOG_DIR"/nosetests.csv
sed -ri '/teardown/d' "$LOG_DIR"/nosetests.csv

# Cleanup
#(
#  echo -en "Cleanup/n"
#bash scripts/python/s3delete.sh
#) >> $LOG_DIR/output.log

(
  echo -en "Cleanup/n"
  bash scripts/s3deletebuckets.sh
  bash scripts/s3wipe.sh
  echo -en "\nRemaining Vaults:\n"
  s3cmd ls | awk '{print $3}' | grep $prefix
) >> "$LOG_DIR"/output.log

exit 0
