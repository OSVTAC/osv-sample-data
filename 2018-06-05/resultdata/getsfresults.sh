#!/bin/sh
#
../../../osv-data-converter/src/getsfresults.py  https://sfelections.sfgov.org/june-5-2018-election-results-detailed-reports
cd resultdata-raw
sha512sum * >sha512sum.txt
zip ../resultdata-raw.zip *