import sys
import csv
import re

from auto_annotate import BaselineRow

def main():
    if len(sys.argv) != 3:
        print >> sys.stderr, 'USAGE: %s results.csv baseline.csv' % (sys.argv[0])
        sys.exit(1)
        
    if not merge_baseline_and_results(sys.argv[1], sys.argv[2]):
        sys.exit(1)
    
def merge_baseline_and_results(results_file, baseline_file):
    baseline_results = {}
    with(open(baseline_file)) as f:
        reader = csv.reader(f)
        header = reader.next()
        for row in map(BaselineRow, reader):
            baseline_results[row.module, row.test] = row

    with open(results_file) as test_results:
        reader = csv.reader(test_results)
        writer = csv.writer(sys.stdout)
        # Write output header
        writer.writerow(header)
        # Skip input header
        next(reader)
        success = True
        for row in map(BaselineRow, sorted(reader)):
            if not row.test or row.module.startswith("<nose"):
                continue
            try:
                baseline_row = baseline_results[row.module, row.test]
                if row.exception == baseline_row.exception and re.search(baseline_row.message, row.message):
                    writer.writerow(baseline_row.as_csv_row())
                else:
                    if row.status == 'PASSED':
                        print >> sys.stderr, '\nNew passing test %s.%s:\nBaseline: %s %s' % (row.module, row.test, baseline_row.exception, baseline_row.message)
                    else:
                        print >> sys.stderr, '\nResult differs from baseline for %s.%s:\nBaseline: %s %s\nCurrent:  %s %s' % (
                                row.module, row.test, baseline_row.exception, baseline_row.message, row.exception, row.message)
                        row.notes = 'TODO'
                        success = False
                    writer.writerow(row.as_csv_row())
            except KeyError:
                if row.status != 'PASSED':
                    print >> sys.stderr, '\nNew failure %s.%s: %s %s' % (row.module, row.test, row.exception, row.message)
                    row.notes = 'TODO'
                    success = False
                writer.writerow(row.as_csv_row())
                
    return success

                
if __name__ == '__main__':
    main()
