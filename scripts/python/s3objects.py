#!/bin/env python

import boto3
import os
from pprint import pprint

os.environ['REQUESTS_CA_BUNDLE'] = '/etc/ssl/certs/ca-bundle.crt'

def main():
    def enumerate_s3_objects():
        s3 = boto3.resource('s3',
             aws_access_key_id='kEA8AdJU4u3PKZxdq1Ae',
             aws_secret_access_key='72vJM62gIjW6PJD03YJvjmyBCKXkWr9sqoNVKYLu',
             endpoint_url='https://mwdc-plt-obj-wip1.nam.nsroot.net')
        for bucket in s3.buckets.all():
             for object in bucket.objects.all():
                 print "s3://" + ("{}".format(object.bucket_name)) + "/" + ("{}".format(object.key))
    enumerate_s3_objects()

if __name__ == '__main__':
    main()

    s3 = boto3.client('s3',   
            aws_access_key_id='kEA8AdJU4u3PKZxdq1Ae',
            aws_secret_access_key='72vJM62gIjW6PJD03YJvjmyBCKXkWr9sqoNVKYLu',
            endpoint_url='https://mwdc-plt-obj-wip1.nam.nsroot.net')
    response = s3.list_buckets()

    #print('Existing buckets:')
    for bucket in response['Buckets']:
         print 's3://' + bucket["Name"]
