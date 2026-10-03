#!/bin/bash

. ../config.sh

c1541command=c1541

cp blank.d64 QUEENS_C128_EN.d64

$c1541command -attach QUEENS_C128_EN.d64 -write C128-queen.prg c128-queen
$c1541command -attach QUEENS_C128_EN.d64 -write text_en.dat "text.dat,s"
$c1541command -attach QUEENS_C128_EN.d64 -write extra/c128-ram.emd "em.drv,s"
$c1541command -attach QUEENS_C128_EN.d64 -write splash.cpr "splash.cpr,s"

cp ../readme.txt .

rm  C128_Queens_en.zip
zip -r C128_Queens_it.zip QUEENS_C128_EN.d64
cp C128_Queens_en.zip $ditdir
