#!/bin/sh
# This script calls the results reporter
orrdir=../../../../../open-results-reporter
rm -rf ../html
orr --input-dir ../out-orr \
    --template-dir $orrdir/templates/demo-template \
    --extra-template-dirs $orrdir/templates/demo-template/extra \
    --output-parent .. \
    --output-subdir html \
    --skip-pdf