#! /usr/bin/env bash

if [[ $# -eq 0 ]] ; then
  echo -en "No argeuments supplied.\n"
  echo -en " tests: run tests\n convert:convert results\n results: move results\n clean:secondary bucket cleanup\n empty: null\n"
  exit 0
fi
 
tests() {
S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit \
    s3tests.functional.test_headers:test_object_create_bad_md5_invalid_short \
    s3tests.functional.test_headers:test_object_create_bad_md5_bad \
    s3tests.functional.test_headers:test_object_create_bad_md5_empty \
    s3tests.functional.test_headers:test_object_create_bad_md5_unreadable \
    s3tests.functional.test_headers:test_object_create_bad_md5_none \
    s3tests.functional.test_headers:test_object_create_bad_expect_mismatch \
    s3tests.functional.test_headers:test_object_create_bad_expect_empty \
    s3tests.functional.test_headers:test_object_create_bad_expect_none \
    s3tests.functional.test_headers:test_object_create_bad_expect_unreadable \
    s3tests.functional.test_headers:test_object_create_bad_contentlength_empty \
    s3tests.functional.test_headers:test_bucket_create_bad_date_before_today_aws2 \
    s3tests.functional.test_headers:test_bucket_create_bad_date_after_today_aws2 \
    s3tests.functional.test_headers:test_bucket_create_bad_date_before_epoch_aws2 \
    s3tests.functional.test_headers:test_object_create_bad_md5_invalid_garbage_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_contentlength_mismatch_below_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_authorization_incorrect_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_authorization_invalid_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_ua_empty_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_ua_unreadable_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_ua_none_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_date_invalid_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_amz_date_invalid_aws4 \
    s3tests.functional.test_headers:test_object_create_bad_date_empty_aws4 \
    s3tests.functional.test_headers:test_bucket_create_bad_amz_date_before_today_aws4 \
    s3tests.functional.test_headers:test_bucket_create_bad_date_after_today_aws4 \
    s3tests.functional.test_headers:test_bucket_create_bad_amz_date_after_today_aws4 \
    s3tests.functional.test_headers:test_bucket_create_bad_date_before_epoch_aws4 \
    s3tests.functional.test_headers:test_bucket_create_bad_amz_date_before_epoch_aws4 \
    s3tests.functional.test_s3:test_bucket_list_empty \
    s3tests.functional.test_s3:test_bucket_list_distinct \
    s3tests.functional.test_s3:test_bucket_list_many \
    s3tests.functional.test_s3:test_bucket_list_delimiter_basic \
    s3tests.functional.test_s3:test_bucket_list_delimiter_prefix \
    s3tests.functional.test_s3:test_bucket_list_delimiter_prefix_ends_with_delimiter \
    s3tests.functional.test_s3:test_bucket_list_delimiter_alt \
    s3tests.functional.test_s3:test_bucket_list_delimiter_prefix_underscore \
    s3tests.functional.test_s3:test_bucket_list_delimiter_percentage \
    s3tests.functional.test_s3:test_bucket_list_delimiter_whitespace \
    s3tests.functional.test_s3:test_bucket_list_delimiter_dot \
    s3tests.functional.test_s3:test_bucket_list_delimiter_unreadable \
    s3tests.functional.test_s3:test_bucket_list_delimiter_empty \
    s3tests.functional.test_s3:test_bucket_list_delimiter_none \
    s3tests.functional.test_s3:test_bucket_list_delimiter_not_exist \
    s3tests.functional.test_s3:test_bucket_list_prefix_basic \
    s3tests.functional.test_s3:test_bucket_list_prefix_alt \
    s3tests.functional.test_s3:test_bucket_list_prefix_empty \
    s3tests.functional.test_s3:test_bucket_list_prefix_none \
    s3tests.functional.test_s3:test_bucket_list_prefix_not_exist \
    s3tests.functional.test_s3:test_bucket_list_prefix_unreadable \
    s3tests.functional.test_s3:test_bucket_list_prefix_delimiter_basic \
    s3tests.functional.test_s3:test_bucket_list_prefix_delimiter_alt \
    s3tests.functional.test_s3:test_region_copy_object
echo "Running Tests"
}
 
convert() {
perl parse-nose.pl -i nosetests.xml -o nosetests.csv
echo "Converting"
}
 
results() {
mkdir -p /RESULTS/
cp nosetests.xml /RESULTS/"$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").xml"
cp nosetests.csv /RESULTS/"$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").csv"
rm nosetests.csv -rf
rm nosetests.xml -rf
echo "Cleaning Results"
}
 
clean() {
source ./s3deletebuckets.sh
echo "Cleanup"
}
 
if [[ $1 -eq tests ]] ; then
                $1
fi
 
if [[ $2 -eq convert ]] ; then
                $2
fi
 
if [[ $3 -eq results ]] ; then
                $3
fi
 
if [[ $4 -eq clean ]] ; then
                $4
fi
 
if [[ $5 -eq empty ]] ; then
                echo
fi
 
exit 0

