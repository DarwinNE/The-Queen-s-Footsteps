#!/bin/bash

. ../config.sh

# Prepare files with a loader for the cas directory

$mkcas --name queen MSX_The_Queen_s_Footsteps/cas/MSXqueens1.cas ascii loader/loader.bas
$mkcas --add --name loading --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens1.cas binary loader/loader.bin
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens1.cas custom-header MSXqueens1

$mkcas --name queen MSX_The_Queen_s_Footsteps/cas/MSXqueens2.cas ascii loader/loader.bas
$mkcas --add --name loading --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens2.cas binary loader/loader.bin
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens2.cas custom-header MSXqueens2

$mkcas --name queen MSX_The_Queen_s_Footsteps/cas/MSXqueens3.cas ascii loader/loader.bas
$mkcas --add --name loading --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens3.cas binary loader/loader.bin
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/cas/MSXqueens3.cas custom-header MSXqueens3


# Copy file without header
cp MSXqueens1.cas MSX_The_Queen_s_Footsteps/no_loader
cp MSXqueens2.cas MSX_The_Queen_s_Footsteps/no_loader
cp MSXqueens3.cas MSX_The_Queen_s_Footsteps/no_loader

# Prepare a single cas file
$mkcas --name queen MSX_The_Queen_s_Footsteps/single_cas/MSXqueens.cas ascii loader/loader.bas
$mkcas --add --name loading --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/single_cas/MSXqueens.cas binary loader/loader.bin
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/single_cas/MSXqueens.cas custom-header MSXqueens1
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/single_cas/MSXqueens.cas custom-header MSXqueens2
$mkcas --add --addr 0x8000 --exec 0x8000 MSX_The_Queen_s_Footsteps/single_cas/MSXqueens.cas custom-header MSXqueens3

# Copy the ROM files
cp MSXqueens1r.rom MSX_The_Queen_s_Footsteps/rom
cp MSXqueens2r.rom MSX_The_Queen_s_Footsteps/rom
cp MSXqueens3r.rom MSX_The_Queen_s_Footsteps/rom

rm  MSX_Queens.zip
zip -r MSX_Queens.zip MSX_The_Queen_s_Footsteps
cp MSX_Queens.zip $ditdir