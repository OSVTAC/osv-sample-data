#!/bin/sh
#
getsfturnout.py -r 2020-03-03
cd turnoutdata-raw
rm sha256sum.txt
sha256sum * >sha256sum.txt
zip ../turnoutdata-raw.zip *