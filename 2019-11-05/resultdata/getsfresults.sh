#!/bin/sh
#
../../../osv-data-converter/src/getsfresults.py  -p -X https://sfelections.sfgov.org/november-5-2019-election-results-detailed-reports
cd resultdata-raw
rm sha512sum.txt sha256sum.txt
sha512sum * >sha512sum.txt
sha256sum * >sha256sum.txt
zip ../resultdata-raw.zip *
../../../osv-data-converter/src/checksfsha.py