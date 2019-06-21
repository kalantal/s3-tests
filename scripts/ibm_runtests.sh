#!/bin/bash

if [ "$S3TEST_CONF" = "" ]; then
    >&2 echo "Set S3TEST_CONF before running the tests."
    exit 1
fi

export BOTO_CONFIG=boto.ini

DATE=$(date +%Y-%m-%d_%H%M)

LOG_DIR=output/$DATE
mkdir -p $LOG_DIR
rm -f output/latest
ln -sf $DATE output/latest

# process-timeout needs to be set to a value greater than the runtime of the longest test, in seconds.
test_cmd="./virtualenv/bin/nosetests -v --with-xunitmp --xunitmp-file=$LOG_DIR/junit.xml --process-timeout=1200 $@"

(
  echo "COMMAND: $test_cmd"
  echo
  echo "ENVIRONMENT:"
  echo "======================================================================"
  env | grep S3
  echo "======================================================================"
  echo
  echo "CONFIG:"
  echo "======================================================================"
  cat $S3TEST_CONF
  echo "======================================================================"
  echo
) > $LOG_DIR/output.log

eval $test_cmd 2>&1 | tee -a $LOG_DIR/output.log

perl parse-nose.pl -i $LOG_DIR/junit.xml -o $LOG_DIR/junit.csv
