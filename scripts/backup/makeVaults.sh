#!/bin/bash

#This is just a small script to create some vaults to test teardown and deletion processes

s3cmd mb s3://s3tests-123456789
	s3cmd put /tmp/* --recursive s3://s3tests-123456789
s3cmd mb s3://s3tests-1234567890
	s3cmd put /tmp/* --recursive s3://s3tests-1234567890
s3cmd mb s3://s3tests-12345678901
	s3cmd put /tmp/* --recursive s3://s3tests-12345678901
