#!/bin/sh
#
# Note: update config-ems.yaml with rotation alphabet etc.
#
echo Converting emsdata-raw.zip/PDMJ001.tsv
dfm-pctdist.py
echo Converting ems-raw.zip/CFMJ001_ContestData.tsv,CFMJ001_ContestCandidateData.tsv
dfm-contcand.py
echo Converting ems-raw.zip/CFMJ008.tsv
dfm-meas.py
echo Converting emsdata-raw.zip/EWMJ014.tsv
dfm-btcont.py
echo Converting emsdata-raw.zip/PODJ011.tsv
dfm-pctpoll.py

# The following requires distname.tsv to be prepared.
dfm-distclass.py