# S3 compatibility tests

Forked from https://github.com/ceph/s3-tests

## Running the tests

### Machine Setup

__On Debian or Ubuntu,__

	./bootstrap


__On OS X,__

	brew install python
	pip install virtualenv
	./bootstrap


### Test Configuration
You will need to create a configuration file with the location of the
service and two different credentials, something like this:

	[DEFAULT]
	## this section is just used as default for all the "s3 *"
	## sections, you can place these variables also directly there

	## Accesser IP
	host = s3.amazonaws.com

	## uncomment the port to use something other than 80
	# port = 8080

	## say "yes" to enable TLS
	is_secure = no

	[fixtures]
	## all the buckets created will start with this prefix;
	## {random} will be filled with random characters to pad
	## the prefix to 30 characters long, and avoid collisions
	bucket prefix = YOURNAMEHERE-{random}-

	[s3 main]
	## the tests assume two accounts are defined, "main" and "alt".

	## id for primary user
	user_id = cb97c802-71aa-4b5f-8d1a-2b0a90908f89

	## display name typically looks more like a unix login, "jdoe" etc
	display_name = youruseridhere

	## replace these with your access keys
	access_key = ABCDEFGHIJKLMNOPQRST
	secret_key = abcdefghijklmnopqrstuvwxyzabcdefghijklmn

	[s3 alt]
	## another user account, used for ACL-related tests
	user_id = d0b97138-9701-47da-937a-f045595366ff
	display_name = john.doe
	## the "alt" user needs to have email set, too
	email = john.doe@example.com
	access_key = NOPQRSTUVWXYZABCDEFG
	secret_key = nopqrstuvwxyzabcdefghijklmnabcdefghijklm

Once you have that, you can run the tests with:

	S3TEST_CONF=your.conf ./virtualenv/bin/nosetests

You can specify what test(s) to run:

	S3TEST_CONF=your.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty

Some tests have attributes set based on their current reliability and
things like AWS not enforcing their spec stricly. You can filter tests
based on their attributes:

	S3TEST_CONF=aws.conf ./virtualenv/bin/nosetests -a '!fails_on_aws'

## Cleversafe Changes

### Test runner script
`runtests.sh` automates a couple of convenience steps:

1. Create a timestamped output directory
2. Run the tests, generating JUnit XML output
3. Generate CSV output from the JUnit XML

Any arguments passed to the script are passed to the `nosetests` test runner.

<strike>The script takes advantage of the [xunitmp](https://github.com/Ignas/nose_xunitmp) plugin to support generating XUnit XML reports when running tests in parallel.</strike>

<strike>Call `runtests.sh` with `--processes=NUM` to run the tests in parallel in `NUM` processes.  Or use `--processes=-1` to create one process per CPU.</strike>

**_There is some nondeterminism present in the tests when run in parallel.  For now, the tests should be run serially._**

### Choosing which tests to run

As seen above, the tests are annotated with tags that can be used to select specific tests.  Rather than adding additional annotations, which would make accepting new changes from Ceph difficult, we dynamically add annotations at runtime using information pulled from CSV files.

__Run the Citi subset of tests:__

	S3_CS_BASELINE=baselines/citi/junit.csv ./runtests.sh -a cs_in_baseline
	
__Run priority 1 tests:__

	S3_CS_BASELINE=baselines/3.8/junit.csv ./runtests.sh -a cs_priority=1
	
__Run tests that passed in the baseline:__

	S3_CS_BASELINE=baselines/3.8/junit.csv ./runtests.sh -a cs_status=PASSED
	
### Comparing expected failures to the baseline

Some of the tests currently fail.
In order to compare test results to an existing baseline, you can enable a feature where tests will only pass if they fail in the same way that they failed in the baseline run.

	S3_CS_BASELINE=baselines/3.8/junit.csv S3_CS_EXPECT_FAILURES=true ./runtests.sh
	
Note that exception message is compared to the baseline via a regular expression search.
If the message contains text that will change from run to run the baseline CSV file may need to be edited to match a pattern rather than a specific string.

### Generating a new baseline
A "baseline" is simply a CSV file generated from a test run that has two additional optional columns: Priority and Notes.

Tests are tagged with their priority (`cs_priority`).  The Notes column is just for human consumption.

To get priority and notes from existing baseline, run

	./virtualenv/bin/python merge_csv.py output/latest/junit.csv baselines/3.8/junit.csv > baselines/baseline-new.csv
	
## Copying baselines for a new release
Each major release of COS has its own set of baselines.  To add support for a new major release, simply copy the current release baselines.  For example:
```
cp -r baselines/3.13 baselines/3.14
git add baselines/3.14
git commit -m "Copy 3.13 baselines for 3.14"
git push
```
