import os
import csv
import inspect
import pydoc
import re

from nose.tools import make_decorator

class BaselineRow(object):
    def __init__(self, csvrow):
        num_fields = 7
        padded_row = csvrow + [''] * max(0, num_fields - len(csvrow))
        (self.module,
         self.test,
         self.status,
         self.exception,
         self.message,
         self.priority,
         self.notes) = padded_row[:num_fields]
        self.other_fields = padded_row[num_fields:]
    
    def __str__(self):
        return ', '.join(self.as_csv_row())
        
    def as_csv_row(self):
        return [self.module, self.test, self.status, self.exception, self.message, self.priority, self.notes] + self.other_fields

def add_annotations():
    if 'S3_CS_BASELINE' not in os.environ:
        return
    with open(os.environ['S3_CS_BASELINE']) as baseline:
        for baseline_row in map(BaselineRow, csv.reader(baseline)):
            add_in_baseline(baseline_row)
            add_priority(baseline_row)
            add_expected_error(baseline_row)
            add_result(baseline_row)
            
def add_in_baseline(row):
    test = _get_test(row.module, row.test)
    if test:
        _set_test_attr(test, 'cs_in_baseline', True)

def add_priority(row):
    if row.priority:
        test = _get_test(row.module, row.test)
        if test:
            _set_test_attr(test, 'cs_priority', row.priority)
                
def add_expected_error(row):
    if not row.exception:
        return
    test = _get_test(row.module, row.test)
    if test:
        module_or_class = pydoc.locate(row.module)
        exception_type = pydoc.locate(row.exception)
        decorator = raises_error_with_message(exception_type, row.message)
        decorated = decorator(test)
        setattr(module_or_class, row.test, decorated)
                
def add_result(row):
    print 'add_result', row
    if not row.status:
        return
    test = _get_test(row.module, row.test)
    if test:
        print 'set cs_status'
        _set_test_attr(test, 'cs_status', row.status)
                
def _set_test_attr(test, attr_name, attr_val):
    if inspect.ismethod(test):
        setattr(test.__func__, attr_name, attr_val)
    else:
        setattr(test, attr_name, attr_val)

def _get_test(module_name, test_name):
    return pydoc.locate('%s.%s' % (module_name, test_name))

def raises_error_with_message(exception, message_pattern):
    """
    Decorator that expects a test to throw an exception with a specific message.
    Used to baseline current test behavior.  Only activated if S3_CS_EXPECT_FAILURES is set.
    """
    def decorate(func):
        if 'S3_CS_EXPECT_FAILURES' not in os.environ:
            return func
        name = func.__name__
        def newfunc(*arg, **kw):
            try:
                func(*arg, **kw)
            except exception as e:
                assert re.search(message_pattern, str(e)), '%s() threw exception with unexpected message.\nExpected: %s\nGot: %s' % (name, message_pattern, e)
            except:
                raise
            else:
                message = "%s() did not raise %s" % (name, exception)
                raise AssertionError(message)
        newfunc = make_decorator(func)(newfunc)
        return newfunc
    return decorate
