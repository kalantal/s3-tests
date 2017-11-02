#! /usr/bin/env bash
 
tests() {
S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit
echo "Running Tests"
}
tests
 
convert() {
perl parse-nose.pl -i nosetests.xml -o nosetests.csv
echo "Converting"
}
convert
 
results() {
rm -rf /RESULTS/
mkdir -p /RESULTS/
cp nosetests.xml /RESULTS/"$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").xml"
cp nosetests.csv /RESULTS/"$(date -d "today" +"s3-test-results-%Y-%m-%d-%H-%M").csv"
rm nosetests.csv -rf
rm nosetests.xml -rf
echo "Cleaning Results"
}
results
 
clean() {
source ./s3deletebuckets_standalone.sh
echo "Cleanup"
}
clean

exit 0
