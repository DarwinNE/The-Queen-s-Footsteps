#!/bin/bash

for d in */ ; do
    echo "$d"
    cd $d
    if test -f "./produce.sh"; then
        ./produce.sh
    else
        echo "WARNING: directory $d does not contain a produce.sh file"
    fi
    cd ..
done
