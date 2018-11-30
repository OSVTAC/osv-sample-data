#!/bin/sh
#
../../../osv-data-converter/src/getsfems.py  2018/Jun
cd emsdata-raw
rm sha512sum.txt
sha512sum * >sha512sum.txt
zip ../ems-raw.zip *