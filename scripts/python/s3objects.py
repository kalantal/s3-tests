#!/bin/env python

import boto3
from pprint import pprint

def main():
    def enumerate_s3_objects():
        s3 = boto3.resource('s3')
        for bucket in s3.buckets.all():
             for object in bucket.objects.all():
                 print "s3://" + ("{}".format(object.bucket_name)) + "/" + ("{}".format(object.key))
    enumerate_s3_objects()

if __name__ == '__main__':
    main()
