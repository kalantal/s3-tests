========================
 S3 compatibility tests
========================

These tests verify ingegrity of an S3-like enviornment. AWS Specific tests have been removed.

To get started, make sure the testing system time and date are accurate. Calls to many object storage enviornements will not allow access if it's not correct.

This test suite takes about an hour to run.

Download the repo::

	git clone https://github.com/kalantal/s3-tests.git

Setup::

	cd s3-tests-master
	chmod u+x bootstrap
	
Prerequisites auto install with ./bootstrap::

	./bootstrap
	
Note that the bootstrap file is a force-installation of dependencies in a RHEL 7.3 environment. There are still some errors and bugs in this procedure, but it functions.

You will need to create a configuration file with the location of the
service and two different credentials. The empty configuraion file is s3.conf::

	[DEFAULT]
	## this section is just used as default for all the "s3 *"
	## sections, you can place these variables also directly there
	
	## replace with e.g. "localhost" to run against local software
	host = s3.amazonaws.com
	
	## uncomment the port to use something other than 80
	# port = 8080
	
	## say "yes" to enable TLS
	is_secure = no
	
	[fixtures]
	## all the buckets created will start with this prefix;
	## {random} will be filled with random characters to pad
	## the prefix to 30 characters long, and avoid collisions
	## lower case only
	bucket prefix = s3-{random}-
	
	[s3 main]
	## the tests assume two accounts are defined, "main" and "alt".
	
	## user_id is a 64-character hexstring
	## located on your security_credential page under "Account Identifiers"
	user_id =
	
	## display name typically looks more like a unix login, "jdoe" etc
	display_name =
	
	## replace these with your access keys
	access_key =
	secret_key =
	
	[s3 alt]
	## another user account, used for ACL-related tests
	user_id =
	display_name =
	## the "alt" user needs to have email set, too
	email =
	access_key =
	secret_key =
	
To install dependancies, run the suite, and call a human-readable file::

	./bootstrap && ./s3nosetests.sh && cat results/nosetests.csv
	
Just running the tests and saving the output in a human-readable format::

	./s3nosetests.sh
	
Test notes:
	The default is all 338 tests found in ./extras/testlist.txt
	34 of the tests listed as "test.fuzzer" are framework tests
	The effective test count: 304

Additonal options and outputs ::

	#To gather a list of tests being run, use the flags:
	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --collect-only
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

You can specify what test(s) to run::

	S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty

Some tests have attributes set based on their current reliability and
things like AWS not enforcing their spec stricly. You can filter tests
based on their attributes::

	S3TEST_CONF=aws.conf ./virtualenv/bin/nosetests -a '!fails_on_aws'
	
========================
         TO DO
========================

	Clean up git pack. 100+ extra MB.
	Temp fix for prod use:
	rm -rf .git

	Nuke_Bucket \ Teardown S3Curl options for troubled permissions.
	bucket prefix "_" does not delete on cleanup (Nuke_Bucket) ex: _s3-p5nfnn3m6xhzxpgyxn5itx7kww-161
	Generally 1 per run.
	
	Calling a test list: S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests $(cat testlist.txt) -v 2>&1 | tee nosetestresults.csv
	
	Pipe output of skips as SKIPS and not SUCCESS.
	#This is a known bug, but the ./parse-nose.pl has some functionallity improvements to be made.
	
Notes::

	[root]# cat /etc/redhat-release
	Red Hat Enterprise Linux Server release 7.3 (Maipo)
	[root]# python --version
	Python 2.7.5

	sudo yum groupinstall "Development tools" -y
	sudo yum install -y epel-release git wget curl
	yum install --downloadonly --downloaddir=./ [packages]
	pip install [package] --download="./"
	xmlutils-1.3.tar.gz is unused
