#!/bin/bash

. ../config.sh

diskimage="queens_plus4.d64"

$c1541command -attach $diskimage -delete loader
$c1541command -attach $diskimage -delete queens-p4
$c1541command -attach $diskimage -write loader/loader.prg loader
$c1541command -attach $diskimage -write p4-queens.prg queens-p4

rm  PLUS4_Queens.zip
zip -r PLUS4_Queens.zip $diskimage
cp PLUS4_Queens.zip $ditdir