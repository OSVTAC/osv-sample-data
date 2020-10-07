#!/bin/sh
#
convomniballot.py -P $*
mv sha256sum.txt sha256sum.txt.prior
sha256sum -b * >sha256sum.txt

