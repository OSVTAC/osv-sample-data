#!/bin/sh
# This script calls the results converter
# It can be modified to change the path or add options
matchcand.py -v  $* 2>&1 |tee matchcand.log
rm sha256sum.txt
sha256sum *.* >sha256sum.txt
