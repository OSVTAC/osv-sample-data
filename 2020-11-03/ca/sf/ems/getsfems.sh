#!/bin/sh
#
getsfems.py  2020/Nov
cd emsdata-raw
sha512sum * >sha512sum.txt
zip ../ems-raw.zip *

# Note: file EWMJ014_ContestBalTypeXref.txt was obtained by email