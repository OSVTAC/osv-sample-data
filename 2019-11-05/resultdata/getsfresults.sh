#!/bin/sh
#
getsfresults.py $* -r -p -X https://sfelections.sfgov.org/november-5-2019-election-results-detailed-reports || exit 1
cd resultdata-raw
rm sha512sum.txt sha256sum.txt
sha512sum * >sha512sum.txt
sha256sum -b * >sha256sum.txt
zip ../resultdata-raw.zip *
cd ..
checksfsha.py