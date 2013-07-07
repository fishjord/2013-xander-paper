#!/bin/bash

workdir=`pwd`
#$(cd `basename $0` &>/dev/null; pwd; cd - &> /dev/null)
targets=$*

if [ ! -e Makefile ]; then
    echo "No makefile found in the current directory!"
    exit 1
fi

echo "Workdir: $workdir"
echo "Targets: $targets"

qsub -l mem=48000mb,walltime=12:00:00 -v workdir=$workdir,targets=$targets ~/bin/make_wrapper.sh
