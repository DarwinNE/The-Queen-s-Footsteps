#!/bin/bash

m68k-amigaos-gcc -s -mcrt=nix13 -m68000 -Os -Wall -o AMIqueen queen_no_UTF8.c inout.c loadsave.c
