#!/bin/sh
# This script calls getomniballot.py to download election definition json
# Parameters are for the City and County of San Francisco (FIPS 06075)
# and election 1485 (November 2019).
#
# To find the codes for an election, use a sample ballot lookup, e.g.
# https://sfelections.org/tools/pollsite/
# with an address, e.g. 551 CONGO ST, 94131, to get links to the
# "Accessible Sample Ballot". It will redirect to:
# https://sites.omniballot.us/06075/app/sb/sample-ballot
# Use your browser's web developer tools to view "Network" XHR,
# Look for the request URL with 2 parameters:
# https://published.omniballot.us/06075/628/styles/lookups.json
#
getomniballot.py  06085 1695