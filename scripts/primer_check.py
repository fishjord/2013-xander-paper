#!/usr/bin/python

import subprocess
import sys
import os
import shutil

if len(sys.argv) != 4:
    print >>sys.stderr, "USAGE: primer_check.py <primers file> <aligned_nucl_file> <errors>"
    sys.exit(1)

primers_file = sys.argv[1]
nucl_file = sys.argv[2]
max_errors = sys.argv[3]
probematch_jar = os.path.join(os.path.split(sys.argv[0])[0], "../jars/ProbeMatch.jar")
readseq_jar = os.path.join(os.path.split(sys.argv[0])[0], "../jars/ReadSeq.jar")

for line in open(primers_file):
    if line[0] == "#":
        continue
    lexemes = line.strip().split()

    primer_name = lexemes[0]
    search_primer = lexemes[2]
    nucl_start = lexemes[3]
    nucl_end = lexemes[4]

    primer_seqfile = "{0}.fasta".format(primer_name)

    cmd = ["java", "-cp", readseq_jar, "edu.msu.cme.rdp.readseq.utils.SequenceTrimmer", "-i", "--length", "10", nucl_start, nucl_end, nucl_file]
    subprocess.check_call(cmd)
    shutil.move("trimmed_{0}".format(nucl_file), primer_seqfile)
    num_seqs = int(subprocess.check_output(["grep", "-c", ">", primer_seqfile]))

    cmd = ["java", "-jar", probematch_jar, search_primer, primer_seqfile, max_errors]
    primer_hits = len(subprocess.check_output(cmd).split("\n"))

    print "{0}\t{1}\t{2}\t{3}".format(primer_name, num_seqs, primer_hits, float(primer_hits) / num_seqs)
