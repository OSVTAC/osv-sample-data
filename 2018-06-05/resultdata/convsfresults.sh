#!/bin/sh
#
../../../osv-data-converter/src/convsfresults.py $*
rm sha512sum.txt
sha512sum *.* >sha512sum.txt