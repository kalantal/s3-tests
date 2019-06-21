#!/bin/bash

#These need to match your specific configuration files
export S3TEST_CONF=s3.conf
export BOTO_CONFIG=boto.ini

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
  cat $S3TEST_CONF
  cat $BOTO_CONFIG
  echo "======================================================================"
  echo
) > $LOG_DIR/output.log

eval $test_cmd 2>&1 | tee -a $LOG_DIR/output.log

perl scripts/parse-nose.pl -i $LOG_DIR/nosetests.xml -o $LOG_DIR/nosetests.csv

sed -ri '/teardown/d' $LOG_DIR/nosetests.csv
