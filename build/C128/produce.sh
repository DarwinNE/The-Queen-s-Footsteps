#!/bin/bash

. ../config.sh

$c1541command -attach QUEENS_C128.d64 -delete c128-queen1
$c1541command -attach QUEENS_C128.d64 -delete c128-queen2
$c1541command -attach QUEENS_C128.d64 -delete c128-queen3

$c1541command -attach QUEENS_C128.d64 -delete splash.cpr

$c1541command -attach QUEENS_C128.d64 -write C128-queen1.prg c128-queen1
$c1541command -attach QUEENS_C128.d64 -write C128-queen2.prg c128-queen2
$c1541command -attach QUEENS_C128.d64 -write C128-queen3.prg c128-queen3

$c1541command -attach QUEENS_C128.d64 -write splash.cpr splash.cpr


rm  C128_Queens.zip
zip -r C128_Queens.zip QUEENS_C128.d64
cp C128_Queens.zip $ditdir