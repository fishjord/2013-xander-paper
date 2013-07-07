#!/usr/bin/python

import sys

if len(sys.argv) != 3:
    print >>sys.stderr, "USAGE: grab.py <ids_file> <file>"
    sys.exit(1)

ids = set()
for line in open(sys.argv[1]):
    line = line.strip()
    if line == "":
        continue
    ids.add(line.split()[0])

for line in open(sys.argv[2]):
    line_id = line.split("\t")[0]

    if line_id in ids:
        print line.strip()
