#!/bin/env python

import boto3
from pprint import pprint

def main():
    def enumerate_s3_buckets():
        s3 = boto3.resource('s3')
        for bucket in s3.buckets.all():
             print "s3://" + ("{}".format(bucket.name))
    enumerate_s3_buckets()

if __name__ == '__main__':
    main()
