#! /usr/bin/env bash

if [[ $# -eq 0 ]] ; then
  echo -en "No argeuments supplied.\n"
  echo -en " tests: run tests\n convert:convert results\n results: move results\n clean:secondary bucket cleanup\n empty: null\n"
  exit 0
fi
 
tests() {
S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit \
    s3tests.functional.test_headers.test_object_create_bad_md5_invalid_short \
    s3tests.functional.test_headers.test_object_create_bad_md5_bad \
    s3tests.functional.test_headers.test_object_create_bad_md5_empty \
    s3tests.functional.test_headers.test_object_create_bad_md5_unreadable \
    s3tests.functional.test_headers.test_object_create_bad_md5_none \
    s3tests.functional.test_headers.test_object_create_bad_expect_mismatch \
    s3tests.functional.test_headers.test_object_create_bad_expect_empty \
    s3tests.functional.test_headers.test_object_create_bad_expect_none \
    s3tests.functional.test_headers.test_object_create_bad_expect_unreadable \
    s3tests.functional.test_headers.test_object_create_bad_contentlength_empty \
    s3tests.functional.test_headers.test_bucket_create_bad_date_before_today_aws2 \
    s3tests.functional.test_headers.test_bucket_create_bad_date_after_today_aws2 \
    s3tests.functional.test_headers.test_bucket_create_bad_date_before_epoch_aws2 \
    s3tests.functional.test_headers.test_object_create_bad_md5_invalid_garbage_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_contentlength_mismatch_below_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_authorization_incorrect_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_authorization_invalid_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_ua_empty_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_ua_unreadable_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_ua_none_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_date_invalid_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_amz_date_invalid_aws4 \
    s3tests.functional.test_headers.test_object_create_bad_date_empty_aws4 \
    s3tests.functional.test_headers.test_bucket_create_bad_amz_date_before_today_aws4 \
    s3tests.functional.test_headers.test_bucket_create_bad_date_after_today_aws4 \
    s3tests.functional.test_headers.test_bucket_create_bad_amz_date_after_today_aws4 \
    s3tests.functional.test_headers.test_bucket_create_bad_date_before_epoch_aws4 \
    s3tests.functional.test_headers.test_bucket_create_bad_amz_date_before_epoch_aws4 \
    s3tests.functional.test_s3.test_bucket_list_empty \
    s3tests.functional.test_s3.test_bucket_list_distinct \
    s3tests.functional.test_s3.test_bucket_list_many \
    s3tests.functional.test_s3.test_bucket_list_delimiter_basic \
    s3tests.functional.test_s3.test_bucket_list_delimiter_prefix \
    s3tests.functional.test_s3.test_bucket_list_delimiter_prefix_ends_with_delimiter \
    s3tests.functional.test_s3.test_bucket_list_delimiter_alt \
    s3tests.functional.test_s3.test_bucket_list_delimiter_prefix_underscore \
    s3tests.functional.test_s3.test_bucket_list_delimiter_percentage \
    s3tests.functional.test_s3.test_bucket_list_delimiter_whitespace \
    s3tests.functional.test_s3.test_bucket_list_delimiter_dot \
    s3tests.functional.test_s3.test_bucket_list_delimiter_unreadable \
    s3tests.functional.test_s3.test_bucket_list_delimiter_empty \
    s3tests.functional.test_s3.test_bucket_list_delimiter_none \
    s3tests.functional.test_s3.test_bucket_list_delimiter_not_exist \
    s3tests.functional.test_s3.test_bucket_list_prefix_basic \
    s3tests.functional.test_s3.test_bucket_list_prefix_alt \
    s3tests.functional.test_s3.test_bucket_list_prefix_empty \
    s3tests.functional.test_s3.test_bucket_list_prefix_none \
    s3tests.functional.test_s3.test_bucket_list_prefix_not_exist \
    s3tests.functional.test_s3.test_bucket_list_prefix_unreadable \
    s3tests.functional.test_s3.test_bucket_list_prefix_delimiter_basic \
    s3tests.functional.test_s3.test_bucket_list_prefix_delimiter_alt \
    s3tests.functional.test_s3.test_bucket_list_prefix_delimiter_prefix_not_exist \
    s3tests.functional.test_s3.test_bucket_list_prefix_delimiter_delimiter_not_exist \
    s3tests.functional.test_s3.test_bucket_create_delete \
    s3tests.functional.test_s3.test_object_read_notexist \
    s3tests.functional.test_s3.test_object_requestid_on_error \
    s3tests.functional.test_s3.test_object_requestid_matchs_header_on_error \
    s3tests.functional.test_s3.test_object_create_unreadable \
    s3tests.functional.test_s3.test_multi_object_delete \
    s3tests.functional.test_s3.test_object_head_zero_bytes \
    s3tests.functional.test_s3.test_object_write_check_etag \
    s3tests.functional.test_s3.test_object_write_cache_control \
    s3tests.functional.test_s3.test_object_write_expires \
    s3tests.functional.test_s3.test_object_write_read_update_read_delete \
    s3tests.functional.test_s3.test_object_set_get_metadata_none_to_good \
    s3tests.functional.test_s3.test_object_set_get_metadata_none_to_empty \
    s3tests.functional.test_s3.test_object_set_get_metadata_overwrite_to_good \
    s3tests.functional.test_s3.test_object_set_get_metadata_overwrite_to_empty \
    s3tests.functional.test_s3.test_object_set_get_unicode_metadata \
    s3tests.functional.test_s3.test_object_set_get_non_utf8_metadata \
    s3tests.functional.test_s3.test_object_set_get_metadata_empty_to_unreadable_prefix \
    s3tests.functional.test_s3.test_object_set_get_metadata_empty_to_unreadable_suffix \
    s3tests.functional.test_s3.test_object_set_get_metadata_empty_to_unreadable_infix \
    s3tests.functional.test_s3.test_object_set_get_metadata_overwrite_to_unreadable_prefix \
    s3tests.functional.test_s3.test_object_set_get_metadata_overwrite_to_unreadable_suffix \
    s3tests.functional.test_s3.test_object_set_get_metadata_overwrite_to_unreadable_infix \
    s3tests.functional.test_s3.test_object_metadata_replaced_on_put \
    s3tests.functional.test_s3.test_object_write_file \
    s3tests.functional.test_s3.test_post_object_anonymous_request \
    s3tests.functional.test_s3.test_post_object_authenticated_request \
    s3tests.functional.test_s3.test_post_object_authenticated_request_bad_access_key \
    s3tests.functional.test_s3.test_post_object_set_success_code \
    s3tests.functional.test_s3.test_post_object_set_invalid_success_code \
    s3tests.functional.test_s3.test_post_object_upload_larger_than_chunk \
    s3tests.functional.test_s3.test_post_object_set_key_from_filename \
    s3tests.functional.test_s3.test_post_object_ignored_header \
    s3tests.functional.test_s3.test_post_object_case_insensitive_condition_fields \
    s3tests.functional.test_s3.test_post_object_escaped_field_values \
    s3tests.functional.test_s3.test_post_object_success_redirect_action \
    s3tests.functional.test_s3.test_post_object_invalid_signature \
    s3tests.functional.test_s3.test_post_object_invalid_access_key \
    s3tests.functional.test_s3.test_object_raw_get_x_amz_expires_not_expired \
    s3tests.functional.test_s3.test_object_raw_get_x_amz_expires_out_range_zero \
    s3tests.functional.test_s3.test_object_raw_get_x_amz_expires_out_max_range \
    s3tests.functional.test_s3.test_object_raw_get_x_amz_expires_out_positive_range \
    s3tests.functional.test_s3.test_object_raw_put \
    s3tests.functional.test_s3.test_object_raw_put_write_access \
    s3tests.functional.test_s3.test_object_raw_put_authenticated \
    s3tests.functional.test_s3.test_object_raw_put_authenticated_expired \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_starts_nonalpha \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_short_empty \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_short_one \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_short_two \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_long \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_250 \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_251 \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_252 \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_253 \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_254 \
    s3tests.functional.test_s3.test_bucket_create_naming_good_long_255 \
    s3tests.functional.test_s3.test_bucket_list_long_name \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_ip \
    s3tests.functional.test_s3.test_bucket_create_naming_bad_punctuation \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_underscore \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_long \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_dash_at_end \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_dot_dot \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_dot_dash \
    s3tests.functional.test_s3.test_bucket_create_naming_dns_dash_dot \
    s3tests.functional.test_s3.test_bucket_create_exists \
    s3tests.functional.test_s3.test_bucket_configure_recreate \
    s3tests.functional.test_s3.test_bucket_get_location \
    s3tests.functional.test_s3.test_bucket_create_exists_nonowner \
    s3tests.functional.test_s3.test_bucket_delete_nonowner \
    s3tests.functional.test_s3.test_bucket_acl_default \
    s3tests.functional.test_s3.test_bucket_acl_canned_during_create \
    s3tests.functional.test_s3.test_bucket_acl_canned \
    s3tests.functional.test_s3.test_bucket_acl_canned_publicreadwrite \
    s3tests.functional.test_s3.test_bucket_acl_canned_authenticatedread \
    s3tests.functional.test_s3.test_object_acl_default \
    s3tests.functional.test_s3.test_object_acl_canned_during_create \
    s3tests.functional.test_s3.test_object_acl_canned \
    s3tests.functional.test_s3.test_object_acl_canned_publicreadwrite \
    s3tests.functional.test_s3.test_object_acl_canned_authenticatedread \
    s3tests.functional.test_s3.test_object_acl_canned_bucketownerread \
    s3tests.functional.test_s3.test_object_acl_canned_bucketownerfullcontrol \
    s3tests.functional.test_s3.test_object_acl_full_control_verify_owner \
    s3tests.functional.test_s3.test_object_acl_full_control_verify_attributes \
    s3tests.functional.test_s3.test_bucket_acl_canned_private_to_private \
    s3tests.functional.test_s3.test_bucket_acl_xml_fullcontrol \
    s3tests.functional.test_s3.test_bucket_acl_xml_write \
    s3tests.functional.test_s3.test_bucket_acl_xml_writeacp \
    s3tests.functional.test_s3.test_bucket_acl_xml_read \
    s3tests.functional.test_s3.test_bucket_acl_xml_readacp \
    s3tests.functional.test_s3.test_object_acl_xml \
    s3tests.functional.test_s3.test_object_acl_xml_write \
    s3tests.functional.test_s3.test_object_acl_xml_writeacp \
    s3tests.functional.test_s3.test_object_acl_xml_read \
    s3tests.functional.test_s3.test_object_acl_xml_readacp \
    s3tests.functional.test_s3.test_bucket_acl_grant_userid_fullcontrol \
    s3tests.functional.test_s3.test_bucket_acl_grant_userid_read \
    s3tests.functional.test_s3.test_bucket_acl_grant_userid_readacp \
    s3tests.functional.test_s3.test_bucket_acl_grant_userid_write \
    s3tests.functional.test_s3.test_access_bucket_publicreadwrite_object_publicread \
    s3tests.functional.test_s3.test_access_bucket_publicreadwrite_object_publicreadwrite \
    s3tests.functional.test_s3.test_object_set_valid_acl \
    s3tests.functional.test_s3.test_object_giveaway \
    s3tests.functional.test_s3.test_buckets_create_then_list \
    s3tests.functional.test_s3.test_list_buckets_anonymous \
    s3tests.functional.test_s3.test_list_buckets_invalid_auth \
    s3tests.functional.test_s3.test_list_buckets_bad_auth \
    s3tests.functional.test_s3.test_bucket_create_naming_good_starts_alpha \
    s3tests.functional.test_s3.test_bucket_create_naming_good_starts_digit \
    s3tests.functional.test_s3.test_bucket_create_naming_good_contains_period \
    s3tests.functional.test_s3.test_bucket_create_naming_good_contains_hyphen \
    s3tests.functional.test_s3.test_bucket_recreate_not_overriding \
    s3tests.functional.test_s3.test_bucket_create_special_key_names \
    s3tests.functional.test_s3.test_bucket_list_special_prefix \
    s3tests.functional.test_s3.test_object_copy_zero_size \
    s3tests.functional.test_s3.test_object_copy_same_bucket \
    s3tests.functional.test_s3.test_object_copy_verify_contenttype \
    s3tests.functional.test_s3.test_object_copy_to_itself \
    s3tests.functional.test_s3.test_object_copy_to_itself_with_metadata \
    s3tests.functional.test_s3.test_object_copy_diff_bucket \
    s3tests.functional.test_s3.test_object_copy_not_owned_bucket \
    s3tests.functional.test_s3.test_object_copy_not_owned_object_bucket \
    s3tests.functional.test_s3.test_object_copy_canned_acl \
    s3tests.functional.test_s3.test_object_copy_retaining_metadata \
    s3tests.functional.test_s3.test_object_copy_replacing_metadata \
    s3tests.functional.test_s3.test_object_copy_bucket_not_found \
    s3tests.functional.test_s3.test_object_copy_key_not_found \
    s3tests.functional.test_s3.test_object_copy_versioned_bucket \
    s3tests.functional.test_s3.test_object_copy_versioning_multipart_upload \
    s3tests.functional.test_s3.test_multipart_upload_empty \
    s3tests.functional.test_s3.test_multipart_upload_small \
    s3tests.functional.test_s3.test_multipart_copy_small \
    s3tests.functional.test_s3.test_multipart_upload \
    s3tests.functional.test_s3.test_multipart_copy_special_names \
    s3tests.functional.test_s3.test_multipart_copy_versioned \
    s3tests.functional.test_s3.test_multipart_upload_resend_part \
    s3tests.functional.test_s3.test_multipart_upload_multiple_sizes \
    s3tests.functional.test_s3.test_multipart_copy_multiple_sizes \
    s3tests.functional.test_s3.test_multipart_upload_size_too_small \
    s3tests.functional.test_s3.test_multipart_upload_contents \
    s3tests.functional.test_s3.test_multipart_upload_overwrite_existing_object \
    s3tests.functional.test_s3.test_abort_multipart_upload \
    s3tests.functional.test_s3.test_abort_multipart_upload_not_found \
    s3tests.functional.test_s3.test_list_multipart_upload \
    s3tests.functional.test_s3.test_multipart_upload_missing_part \
    s3tests.functional.test_s3.test_multipart_upload_incorrect_etag \
    s3tests.functional.test_s3.test_100_continue \
    s3tests.functional.test_s3.test_bucket_acls_changes_persistent \
    s3tests.functional.test_s3.test_atomic_dual_write_8mb \
    s3tests.functional.test_s3.test_atomic_conditional_write_1mb \
    s3tests.functional.test_s3.test_atomic_dual_conditional_write_1mb \
    s3tests.functional.test_s3.test_atomic_write_bucket_gone \
    s3tests.functional.test_s3.test_atomic_multipart_upload_write \
    s3tests.functional.test_s3.test_multipart_resend_first_finishes_last \
    s3tests.functional.test_s3.test_ranged_request_response_code \
    s3tests.functional.test_s3.test_ranged_request_skip_leading_bytes_response_code \
    s3tests.functional.test_s3.test_ranged_request_return_trailing_bytes_response_code \
    s3tests.functional.test_s3.test_ranged_request_invalid_range \
    s3tests.functional.test_s3.test_ranged_request_empty_object \
    s3tests.functional.test_s3.check_can_test_multiregion \
    s3tests.functional.test_s3.test_region_bucket_create_secondary_access_remove_master \
    s3tests.functional.test_s3.test_region_bucket_create_master_access_remove_secondary \
    s3tests.functional.test_s3.test_region_copy_object \
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

