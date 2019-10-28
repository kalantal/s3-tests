#!/usr/bin/perl

use XML::Simple;
use XML::LibXML;
use Data::Dumper;
use Getopt::Std;

sub print_XML {
        my($xml,$parser);
        ($xml)=@_;
        ($debug) && print OUTFILE "Sub print_XML: Entry\n";

        $parser = XML::LibXML->new->parse_string($xml)->toString(2);
        print OUTFILE Dumper($parser);
        ($debug) && print OUTFILE "Sub print_XML: Exit\n";
        }

#Main

getopts('hdi:o:',\%args)||die "Error parsing arguments, use -h to show arguments $!\n";

if (($args{h}) or ($args{i} eq "")) {
        print "parse-nose.pl -i <input XML file> [-h] [-d] [ -o <output file>]\n-h = Help\n-d = Script debug enable\n-i = file containing commands\n-o = Output file\n\n";
        exit;
        }

if ($args{d}) {$debug=1} else {$debug=0};
if ( -r $args{i}) {$xmlfilename = $args{i}} else {die "Can't open input file $args{i}\n";}
if ($args{o} ne "") {$output_file = $args{o}}
        else {$output_file="-";}

open(OUTFILE,">$output_file")||die "Error opening ouput file $output_file: $!\n";

$parser = XML::LibXML->new();
$tests = $parser->parse_file($xmlfilename);
print OUTFILE "Module,Test,Test status,Error/Failure Type,Error/Failure Message\n";

foreach $testsuite ($tests->findnodes('/testsuite')) {
	$test_num = $testsuite->getAttribute('tests');
	$test_errors = $testsuite->getAttribute('errors');
	$test_failures = $testsuite->getAttribute('failures');
	$test_skip = $testsuite->getAttribute('skip');
	foreach $test ($testsuite->findnodes('./testcase')) {
		my ($error_type,$failure_type);
		my ($classname) = $test->getAttribute('classname');
		my ($testname) = $test->getAttribute('name');
		print OUTFILE "$classname,$testname,";
		foreach $testerror ($test->findnodes('./error')) {
			$error_type = $testerror->getAttribute('type');
			$error_temp = $testerror->getAttribute('message');
			}
		foreach $testfailure ($test->findnodes('./failure')) {
			$failure_type = $testfailure->getAttribute('type');
			$failure_temp = $testfailure->getAttribute('message');
			}
		if ($error_type ne '') {
			($error_message,$junk) = split(/^/,$error_temp,2);
			chomp $error_message;
			$error_message =~ s/,/|/g;
			print OUTFILE "ERROR, $error_type, $error_message\n";
			} elsif ($failure_type ne '') {
				($failure_message,$junk) = split(/^/,$failure_temp,2);
				chomp $failure_message;
				$failure_message =~ s/,/|/g;
				print OUTFILE "FAILED, $failure_type, $failure_message\n";
				} else {
					print OUTFILE "PASSED, \n";
					}
		}
	}

print OUTFILE "Tests = $test_num Errors = $test_errors Failures = $test_failures Skip = $test_skip\n";

close(OUTFILE);
