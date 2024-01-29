#!/bin/bash

. ../config.sh

rm  Atari_Queens.zip

# I am using instead the Atari800_Silk.atr file that contains the DOS 2.51 and
# allows to boot the system, provided by Filippo Santellocco.

$ataritools AtariQueens.atr rm queens1.com
$ataritools AtariQueens.atr rm queens2.com
$ataritools AtariQueens.atr rm queens3.com

$ataritools AtariQueens.atr put Atari_The_Queen_s_Footsteps/queens1.xex  queens1.com
$ataritools AtariQueens.atr put Atari_The_Queen_s_Footsteps/queens2.xex  queens2.com
$ataritools AtariQueens.atr put Atari_The_Queen_s_Footsteps/queens3.xex  queens3.com

zip -r Atari_Queens.zip AtariQueens.atr Atari_The_Queen_s_Footsteps
cp Atari_Queens.zip $ditdir