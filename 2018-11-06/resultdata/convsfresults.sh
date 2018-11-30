#!/bin/sh
# This script calls the results converter
# It can be modified to change the path or add options
../../../osv-data-converter/src/convsfresults.py -v $*
rm sha512sum.txt
sha512sum *.* >sha512sum.txt
