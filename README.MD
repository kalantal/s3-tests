 S3 compatibility tests
========================

These tests verify ingegrity of an S3-like enviornment.

Setup:

	sudo chmod +x bootstrap
	sudo ./bootstrap

You will need to create a configuration file with credentials. The empty configuraion file is:

	s3.conf_sample
	
Notes:

	This is built to run in a RHEL 7.7 environment
	If you want to change the prefix, you need to change it in:
		run_all.sh scripts/s3deletebuckets.sh scripts/s3wipe.sh
		Hardcoded to prevent a user from creating vaults with no pragmatic way to clean up
	Do not use keys with escape characters unless you manually build all your key files
	The scripts assume the configuration file is named: s3.conf
	"testlist" and "testlist-with-blacklist" contain a list of all tests that can run
	The default run of the suite is with the blacklist: blacklist/blacklist.txt
	The effective test count: 553 (with blacklist)
	Make sure the testing system time and date are accurate
	#non-standard naming in tests
	s3tests_boto3.functional.test_s3.test_lifecycle_expiration_header_head
	s3tests_boto3.functional.test_s3.test_lifecycle_expiration_header_put
	
Quick Start:
	
	./run_all.sh
	or
	nohup ./run_all.sh > /tmp/nohup.out 2>&1 </dev/null &
	tail -f /tmp/nohup.out
	
Additonal options and outputs:

	#To gather a list of tests being run, use the flags: -v --collect-only
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --collect-only 2>&1 | tee output/testlists/testlist.txt
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --collect-only --with-blacklist --blacklist-file=blacklists/blacklist.txt 2>&1 | tee output/testlists/testlist-with-blacklist.txt
	
	#Run tests to Raw CSV
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v 2>&1 | tee output/nosetestresults.csv
	
	#Run tests to Raw XML
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --xunit-file=output/nosetests.xml
	
	#Conversation for XML to Human-Readable CSV/XLS
	perl parse-nose.pl -i nosetests.xml -o nosetests.csv

	#You can specify what test(s) to run:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty -v 2>&1 | tee output/nosetestresults.csv

	#You can filter tests based on their attributes:
	S3TEST_CONF=aws.conf ./virtualenv/bin/nosetests -a '!fails_on_aws' -v 2>&1 | tee output/nosetestresults.csv

	#Tests can be run in a list:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --xunit-file=output/nosetests.xml \
		s3tests.functional.test_headers:test_object_create_bad_md5_invalid_short \
		
	#Tests can be blacklisted:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit --with-blacklist --blacklist-file=blacklists/blacklist.txt --xunit-file=output/nosetests.xml
	
	#Test only Boto3 tests:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests --with-xunit --xunit-file=output/nosetests.xml -v -s -A 'not fails_on_rgw' s3tests_boto3.functional
		
	#Debug (Any stdout output will be printed immediately)
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -vv -s 2>&1 | tee output/$(date +%Y-%m-%d_%H%M)_debug_run
