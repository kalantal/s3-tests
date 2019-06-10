 S3 compatibility tests
========================

These tests verify ingegrity of an S3-like enviornment.

Setup:

	sudo chmod u+x bootstrap
	sudo ./bootstrap

You will need to create configuration files with two different credentials. The empty configuraion files are:

	sample_s3.conf
	sample_boto.conf
	
Notes:

	This is built to run in a RHEL 7.6 environment.
	The default run is all tests, which can be found in "testlist"
	34 of the tests listed as "test.fuzzer" are framework tests
	The effective test count: 525 (with blacklist)
	Make sure the testing system time and date are accurate.
	
Quick Start:
	
	./run_all.sh
	
Additonal options and outputs:

	#To gather a list of tests being run, use the flags: -v --collect-only
	#s3tests.functional.test_s3_website.test_routing_generator -- needs to be stripped, as well as the " ... ok" 
	#As well as the trailing test success notification at the bottom of the file
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --collect-only 2>&1 | tee testlist
	
	#Run tests to Raw CSV
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v 2>&1 | tee nosetestresults.csv
	
	#Run tests to Raw XML
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --xunit-file=nosetests.xml
	
	#Conversation for XML to Human-Readable CSV/XLS
	perl parse-nose.pl -i nosetests.xml -o nosetests.csv

	#You can specify what test(s) to run:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty

	#You can filter tests based on their attributes:
	S3TEST_CONF=aws.conf ./virtualenv/bin/nosetests -a '!fails_on_aws'

	#Tests can be run in a list:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit \
		s3tests.functional.test_headers:test_object_create_bad_md5_invalid_short \
		
	#Tests can be blacklisted:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --with-blacklist --blacklist-file=blacklists/blacklist.txt
	
	#Test only Boto3 tests:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v -s -A 'not fails_on_rgw' s3tests_boto3.functional
		
	#Debug (Any stdout output will be printed immediately)
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -vv -s 2>&1 | tee output/$(date +%Y-%m-%d_%H%M)_debug_run
