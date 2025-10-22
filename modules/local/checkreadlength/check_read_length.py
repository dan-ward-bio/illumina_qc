#!/usr/bin/env python3
"""
Check if maximum read length in a TSV file exceeds threshold.
"""

import sys
import csv

tsv_file = sys.argv[1]

with open(tsv_file, 'r') as f:
    reader = csv.DictReader(f, delimiter='\t')
    
    for row in reader:
        max_len = int(row['max_len'])
        if max_len > 1500:
            print(f"Error: Read length {max_len} exceeds threshold of 1500 bp. This is most likely long-read data")
            sys.exit(1)

sys.exit(0)
