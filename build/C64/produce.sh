#!/bin/bash

. ../config.sh

$c1541command -attach QUEENS_C64.d64 -delete queens-64-1
$c1541command -attach QUEENS_C64.d64 -delete queens-64-2
$c1541command -attach QUEENS_C64.d64 -delete queens-64-3

$c1541command -attach QUEENS_C64.d64 -delete loader

$c1541command -attach QUEENS_C64.d64 -write C64_loader/loader.prg loader
$c1541command -attach QUEENS_C64.d64 -write queens-64-1.prg queens-64-1
$c1541command -attach QUEENS_C64.d64 -write queens-64-2.prg queens-64-2
$c1541command -attach QUEENS_C64.d64 -write queens-64-3.prg queens-64-3


rm  C64_Queens.zip
zip -r C64_Queens.zip QUEENS_C64.d64
cp C64_Queens.zip $ditdir