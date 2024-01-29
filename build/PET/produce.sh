#!/bin/bash

. ../config.sh

rm  PET_Queens.zip
zip -r PET_Queens.zip PET40 PET80
cp PET_Queens.zip $ditdir