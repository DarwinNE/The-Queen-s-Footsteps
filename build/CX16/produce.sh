#!/bin/bash

. ../config.sh

rm  CX16_Queens.zip
zip -r CX16_Queens.zip TQF1.PRG TQF2.PRG TQF3.PRG
cp CX16_Queens.zip $ditdir