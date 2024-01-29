#!/bin/bash

. ../config.sh

rm  Z88_Queens.zip

cp ../readme.txt .


rm -r Z88_Queens
mkdir Z88_Queens
mkdir Z88_Queens/epr
mkdir Z88_Queens/app
mkdir Z88_Queens/bas

cp readme.txt Z88_Queens
cp notes_z88.txt Z88_Queens

# .epr files are for emulators
cp TQF1.epr Z88_Queens/epr
cp TQF2.epr Z88_Queens/epr
cp TQF3.epr Z88_Queens/epr

# .app files for installing application in RAM
cp TQF1.ap* Z88_Queens/app
cp TQF2.ap* Z88_Queens/app
cp TQF3.ap* Z88_Queens/app

# .BAS files for the BBC basic
cp TQF1.BAS Z88_Queens/bas
cp TQF2.BAS Z88_Queens/bas
cp TQF3.BAS Z88_Queens/bas


zip -r Z88_Queens.zip Z88_Queens
cp Z88_Queens.zip $ditdir