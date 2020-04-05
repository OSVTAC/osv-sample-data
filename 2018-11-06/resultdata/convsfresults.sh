#!/bin/sh
# This script calls the results converter
# It can be modified to change the path or add options
convvbmprecinct.py
convsfresults-18.py -P $*
