#!/usr/bin/python

import boto3
import os

from pprint import pprint 

os.environ['REQUESTS_CA_BUNDLE'] = '/etc/ssl/certs/ca-bundle.crt'

def main(): 

    #boto3.set_stream_logger('')
    s3 = boto3.client('s3',   
            aws_access_key_id='',
            aws_secret_access_key='',
            endpoint_url='https://')
    response = s3.list_buckets()

    #print('Existing buckets:')
    for bucket in response['Buckets']:
         print 's3://' + bucket["Name"]

if __name__ == '__main__': 
     main()
