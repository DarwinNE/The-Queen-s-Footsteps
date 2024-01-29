#!/bin/bash

. ../config.sh


echo "Copy Amiga files"

outputfile="AMIqueen.adf"

rm $outputfile
$xdftoolcommand $outputfile format "The Queen's Footsteps"
$xdftoolcommand $outputfile boot install boot1x
$xdftoolcommand $outputfile makedir C
$xdftoolcommand $outputfile makedir S
$xdftoolcommand $outputfile makedir libs
$xdftoolcommand $outputfile write disk.info /

$xdftoolcommand $outputfile write AMIqueen /
$xdftoolcommand $outputfile write AMIqueens.info /
$xdftoolcommand $outputfile write AMIqueens /

$xdftoolcommand $outputfile write tdttr /
$xdftoolcommand $outputfile write AMItdttr.info /
$xdftoolcommand $outputfile write AMItdttr /



$xdftoolcommand $outputfile write loader C/
$xdftoolcommand $outputfile write startup-sequence S/

zip -r AMIqueen.zip $outputfile
cp AMIqueen.zip $ditdir