#!/bin/sh
# This script calls the results converter
# It can be modified to change the path or add options

# First, preprocess the turnout data:
convvbmprecinct.py -x

# Create the ../out-orr/resultdata files:
convsfresults.py -v -P $*

