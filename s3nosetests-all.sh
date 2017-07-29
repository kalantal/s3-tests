#! /usr/bin/env bash
 
if [[ $# -eq 0 ]] ; then
  echo -en "No argeuments supplied.\n"
  echo -en " tests: run tests\n convert:convert results\n results: move results\n clean:secondary bucket cleanup\n empty: null\n"
  exit 0
fi
 
tests() {
S3TEST_CONF=s3.conf ./virtualenv/bin/nosetests -v --with-xunit
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
source ./deletes3buckets.sh
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

