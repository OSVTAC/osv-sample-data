#!/bin/bash
#
# Regenerate all conversions for all election dates
for d in ../201[89]* ../2020*/ca/sf
do
    pushd $d/resultdata
    pwd
    echo ./convsfresults.sh ...
    ./convsfresults.sh
    cd ../omniballot
    pwd
    echo ./updategroups.sh ...
    ./updategroups.sh
    echo ./convomniballot.sh ...
    ./convomniballot.sh
    popd
done