#!/bin/bash

. ../config.sh

$pp/gfx2crtc/png2crtc loading.png loading 7 0
$pp/dump-pal.py loading.png pal

rm queen2 queen3
mv queen2.cpc queen2
mv queen3.cpc queen3


rm CPC_Queens.dsk
$pp/iDSK/idsk CPC_Queens.dsk -n
$pp/iDSK/idsk CPC_Queens.dsk -i disc.bas -f -t 1 -c c000
$pp/iDSK/idsk CPC_Queens.dsk -i loading -t 1 -c c000 -f
$pp/iDSK/idsk CPC_Queens.dsk -i pal -f -t 1 -c a000
$pp/iDSK/idsk CPC_Queens.dsk -i CPCqueen.cpc -f
$pp/iDSK/idsk CPC_Queens.dsk -i queen2 -f
$pp/iDSK/idsk CPC_Queens.dsk -i queen3 -f


rm  CPC_Queens.zip
zip -r CPC_Queens.zip CPC_Queens.dsk

cp CPC_Queens.zip $ditdir
