#!/bin/bash

. ../config.sh

rm  MSDOS_Queens.zip
zip -r MSDOS_Queens.zip QUEENS.EXE QUEENSN.EXE
cp MSDOS_Queens.zip $ditdir
