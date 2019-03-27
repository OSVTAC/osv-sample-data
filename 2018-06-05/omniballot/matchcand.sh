#!/bin/sh
# This script calls the results converter
# It can be modified to change the path or add options
../../../osv-data-converter/src/matchcand.py -v  $* 2>&1 |tee matchcand.log
../../../osv-data-converter/src/matchcand.py -S .ems -v  $* 2>&1 |tee matchcand.ems.log
