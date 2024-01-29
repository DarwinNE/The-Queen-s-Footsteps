#!/bin/bash

. ../config.sh

# Put all the .tap files in the 48K directory
cp 48K/*.tap ZX_The_Queen_s_Footsteps/48K

# Notes for this distribution.
cp notes_ZXSpectrum.txt ZX_The_Queen_s_Footsteps

cp P3/*.dsk ZX_The_Queen_s_Footsteps/P3

rm  ZX_Queens.zip
zip -r ZX_Queens.zip ZX_The_Queen_s_Footsteps
cp ZX_Queens.zip $ditdir

exit

# The remaining code does not work properly :-(
# I think iDSK is not the right tool for it.


# Extract the executable from each disk image as produced by Z88dk.
$pp/idsk/iDSK P3/ZXqueens1P3.dsk -g ZXQUEENS.BIN
$pp/idsk/iDSK P3/ZXqueens1P3.dsk -g ZXQUEENS.SCR
# Rename each part as a different file.
mv ZXQUEENS.BIN queens1.bin
$pp/idsk/iDSK P3/ZXqueens2P3.dsk -g ZXQUEENS.BIN
mv ZXQUEENS.BIN queens2.bin
$pp/idsk/iDSK P3/ZXqueens3P3.dsk -g ZXQUEENS.BIN
mv ZXQUEENS.BIN queens3.bin

# Remove the old disk image
rm ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk
# Create a new disk image and import the three files for TQF.
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -n
# Loader
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -i DISK.
# Loading screen
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -i ZXQUEENS.SCR
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -i queens1.bin -f
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -i queens2.bin -f
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/SPC3queen.dsk -i queens3.bin -f




# The +3 version also contains Two Days to the Race
rm ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk
cp P3/tdttr/ZXtwoda1.dsk ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk

# Extract the second part of TDTTR
$pp/idsk/iDSK P3/tdttr/ZXtwoda2.dsk -g ZXTWODA2.BIN
$pp/idsk/iDSK P3/tdttr/ZXtwoda2.dsk -g DISK.
mv DISK. PART2

# Extract the third part of TDTTR
$pp/idsk/iDSK P3/tdttr/ZXtwoda3.dsk -g ZXTWODA3.BIN
$pp/idsk/iDSK P3/tdttr/ZXtwoda3.dsk -g DISK.
mv DISK. PART3

# Insert the part 2 and 3 of TDTTR into the TDTTR disk
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk -i PART2
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk -i ZXTWODA2.BIN
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk -i PART3
$pp/idsk/iDSK ZX_The_Queen_s_Footsteps/P3/TDTTR.dsk -i ZXTWODA3.BIN


rm  ZX_Queens.zip
zip -r ZX_Queens.zip ZX_The_Queen_s_Footsteps
cp ZX_Queens.zip $ditdir