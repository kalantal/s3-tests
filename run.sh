#!/bin/bash

export S3TEST_CONF=s3.conf
export BOTO_CONFIG=boto.conf

DATE=$(date +%Y-%m-%d_%H%M)

LOG_DIR=output/$DATE
mkdir -p $LOG_DIR

# process-timeout needs to be set to a value greater than the runtime of the longest test, in seconds.
test_cmd="./virtualenv/bin/nosetests -vv"

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
  echo "======================================================================"
  echo
) > $LOG_DIR/output.log

eval $test_cmd 2>&1 | tee -a $LOG_DIR/output.log
