#!/bin/bash


# All names of the tools used for accessing the disk images in the different
# platforms are defined in a single config file in the parent directory:
. ../config.sh

# Assemble the disk image
cp dsk/prodos.po ./queens_en.po
java -jar $acjarfile -as ./queens_en.po STARTUP < splash.bin
java -jar $acjarfile -as ./queens_en.po GAME < queens_en.bin
java -jar $acjarfile -p ./queens_en.po SPLASH.HGR 0 < dsk/splash.hgr
java -jar $acjarfile -p ./queens_en.po EM.DRV 0 < dsk/a2e.auxmem.emd
java -jar $acjarfile -p ./queens_en.po TEXT.DAT 0 < text_en.dat

rm  AppleIIe_Queens_EN.zip
zip -r AppleIIe_Queens_EN.zip queens_en.po
cp AppleIIe_Queens_EN.zip $ditdir
