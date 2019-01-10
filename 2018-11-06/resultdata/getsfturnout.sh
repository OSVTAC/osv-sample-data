#!/bin/sh
#
../../../osv-data-converter/src/getsfturnout.py  2018-11-06
cd turnoutdata-raw
rm sha256sum.txt
sha256sum * >sha256sum.txt
zip ../turnoutdata-raw.zip *