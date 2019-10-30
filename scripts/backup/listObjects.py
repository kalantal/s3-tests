#!/bin/python

import boto3

s3 = boto3.resource('s3',
endpoint_url = 'http://111.222.333.444:80',
aws_access_key_id = '1234567890',
aws_secret_access_key = '1234567890')

for bucket in s3.buckets.all():
	print "s3://" + (bucket.name)
