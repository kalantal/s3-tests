from boto.exception import S3ResponseError
import boto.s3.connection

import auto_annotate
from s3tests import functional
from s3tests.functional import nuke_prefixed_buckets

import os

from multiprocessing.dummy import Pool


# Dynamically add annotations and attributes from CSV files
auto_annotate.add_annotations()

# Track created buckets for a cleanup double-check.
# Does not support multi-process parallelism.
created_buckets = []
        
def remember_created_buckets(create_bucket_fn):
    """
    The nuke_prefixed_buckets teardown cleans up most of the created buckets,
    but there are a few cases where buckets aren't cleaned up- mostly in tests
    where the bucket creation is expected to fail, and in our case it passes.
    """
    def create_bucket(connection, bucket_name, **kwargs):
        result = create_bucket_fn(connection, bucket_name, **kwargs)
        created_buckets.append(result)
        return result
    return create_bucket

setattr(boto.s3.connection.S3Connection, 'create_bucket', remember_created_buckets(boto.s3.connection.S3Connection.create_bucket))

def teardown():
    while created_buckets:
        delete_bucket(created_buckets.pop())
            
def async_teardown():
    while created_buckets:
        pool.apply_async(delete_bucket, (created_buckets.pop(),))
            
def delete_bucket(b):
    try:
        for key in b.list():
            b.delete_key(key.name, version_id=key.version_id)
            b.delete()
    except S3ResponseError:
        pass
        
# Force S3 website tests to skip
import s3tests.functional.test_s3_website
s3tests.functional.test_s3_website.CAN_WEBSITE = False
 
def fn_teardown(existing_teardown_fn):
    def new_teardown():
        if callable(existing_teardown_fn):
            existing_teardown_fn()
        async_teardown()
    return new_teardown
 
if 'S3_DO_PER_TEST_CLEANUP' in os.environ:
    pool = Pool(20)
    
    # Don't do module teardown because we'll delete buckets per-test.
    delattr(s3tests.functional, 'teardown')
    
    import s3tests.functional.test_s3
    import s3tests.functional.test_headers
    for name, value in s3tests.functional.test_s3.__dict__.items() + s3tests.functional.test_headers.__dict__.items():
        if callable(value) and name.startswith('test_'):
            value.teardown = fn_teardown(getattr(value, 'teardown', None))
