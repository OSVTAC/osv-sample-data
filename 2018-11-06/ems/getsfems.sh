#!/bin/sh
#
../../../osv-data-converter/src/getsfems.py  2018/Nov
cd emsdata-raw
sha512sum * >sha512sum.txt
zip ../ems-raw.zip *

# Note: file EWMJ014_ContestBalTypeXref.txt was obtained by email