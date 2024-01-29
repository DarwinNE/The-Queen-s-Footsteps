#!/bin/bash

. ../config.sh

rm  MAC68k_queens_footsteps.zip
zip -r MAC68k_queens_footsteps.zip "The Queen's Footsteps.dsk"
cp MAC68k_queens_footsteps.zip $ditdir
