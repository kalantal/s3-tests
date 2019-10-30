#!/bin/env python

import boto3
from pprint import pprint

def main():

    def enumerate_s3_buckets():
        print "Bucket list:"
        s3 = boto3.resource('s3')
        endpoint_url = 's3.amazonaws.com',
        for bucket in s3.buckets.all():
             print "s3://" + ("{}".format(bucket.name))
    enumerate_s3_buckets()
    
    print

    def enumerate_s3_objects():
        print "Object list:"
        s3 = boto3.resource('s3')
        endpoint_url = 's3.amazonaws.com',
        for bucket in s3.buckets.all():
             for object in bucket.objects.all():
                 print "s3://" + ("{}".format(object.bucket_name)) + "/" + ("{}".format(object.key))
    enumerate_s3_objects()

if __name__ == '__main__':
    main()
