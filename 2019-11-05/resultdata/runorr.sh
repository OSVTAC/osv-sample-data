#!/bin/sh
# This script calls the results reporter
rm -rf ../html
orr --input-dir ../out-orr \
    --template-dir ../../../open-results-reporter/templates/demo-template \
    --extra-template-dirs ../../../open-results-reporter/templates/demo-template/extra \
    --output-parent .. \
    --output-subdir html \
    --skip-pdf