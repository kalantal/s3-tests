#!/bin/env python

import boto3
import os
from pprint import pprint

os.environ['REQUESTS_CA_BUNDLE'] = '/etc/ssl/certs/ca-bundle.crt'

def main():
    def enumerate_s3_buckets():
        s3 = boto3.resource('s3')
        for bucket in s3.buckets.all():
             print "s3://" + ("{}".format(bucket.name))
    enumerate_s3_buckets()

if __name__ == '__main__':
    main()
