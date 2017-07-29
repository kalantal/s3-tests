#! /usr/bin/env bash

#Not verbose
#S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests

#Saves to .XML
S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit
#S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit 2>&1 | tee rawresults.txt

#Saves raw output
#S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v 2>&1 | tee nosetestresults.txt

#convert xml to csv with perl
perl parse-nose.pl -i nosetests.xml -o nosetests.csv

#move final output to the results folder
mkdir -p ./results/

cp nosetests.xml results/$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").xml
cp nosetests.csv results/$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").csv

rm nosetests.csv -rf
rm nosetests.xml -rf

./s3deletebuckets.sh

#FOR CITI ONLY
#mkdir -p /auto/RESULTS/s3tests/
#cp nosetests.xml /auto/RESULTS/s3tests/$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").xml
#cp nosetests.csv /auto/RESULTS/s3tests/$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").csv
#rm nosetests.csv
#rm nosetests.xml
