#!/bin/bash

. ../config.sh

$c1541command -attach QUEENS_VIC20.d64 -delete loader
$c1541command -attach QUEENS_VIC20.d64 -delete queens-vic1
$c1541command -attach QUEENS_VIC20.d64 -delete himem1.bin
$c1541command -attach QUEENS_VIC20.d64 -delete queens-vic2
$c1541command -attach QUEENS_VIC20.d64 -delete himem2.bin
$c1541command -attach QUEENS_VIC20.d64 -delete queens-vic3
$c1541command -attach QUEENS_VIC20.d64 -delete himem3.bin

$c1541command -attach QUEENS_VIC20.d64 -write  loader/loader.prg loader

$c1541command -attach QUEENS_VIC20.d64 -write  queens-vic1.prg  queens-vic1
$c1541command -attach QUEENS_VIC20.d64 -write  himem1.bin
$c1541command -attach QUEENS_VIC20.d64 -write  queens-vic2.prg  queens-vic2
$c1541command -attach QUEENS_VIC20.d64 -write  himem2.bin
$c1541command -attach QUEENS_VIC20.d64 -write  queens-vic3.prg  queens-vic3
$c1541command -attach QUEENS_VIC20.d64 -write  himem3.bin

rm  VIC20_Queens.zip
zip -r VIC20_Queens.zip QUEENS_VIC20.d64
cp VIC20_Queens.zip $ditdir