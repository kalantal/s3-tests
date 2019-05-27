 S3 compatibility tests
========================

These tests verify ingegrity of an S3-like enviornment.

This test suite takes about an hour to run.

Setup:

	sudo chmod u+x bootstrap
	sudo ./bootstrap
	
This is built to run in a RHEL 7.6 environment.

You will need to create configuration files with two different credentials. The empty configuraion files are s3.conf & boto.conf
	
Test notes:

	The default run is all tests, which can be found in "testlist"
	34 of the tests listed as "test.fuzzer" are framework tests
	The effective test count: 638
	Make sure the testing system time and date are accurate.
	
Additonal options and outputs:

	#To gather a list of tests being run, use the flags:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --collect-only 2>&1 | tee testlist
	#Note that the output does not add ":" between the test prefix and the test name
	#ex: s3tests.functional.test_s3.test_bucket_list_empty needs to be -> s3tests.functional.test_s3:test_bucket_list_empty to pass them in as a "test list".

	#Run tests to Console
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests
	
	#Run tests to Raw CSV
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v 2>&1 | tee nosetestresults.csv
	
	#Run tests to Raw XML
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit
	
	#Conversation for XML to Human-Readable CSV/XLS
	perl parse-nose.pl -i nosetests.xml -o nosetests.csv

You can specify what test(s) to run:

	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty

Some tests have attributes set based on their current reliability and
things like AWS not enforcing their spec stricly. You can filter tests
based on their attributes::

	S3TEST_CONF=aws.conf ./virtualenv/bin/nosetests -a '!fails_on_aws'
