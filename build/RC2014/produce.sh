#!/bin/bash

. ../config.sh

cp RC2014queens1.ihx RC2014_The_Queen_s_Footsteps
cp RC2014queens2.ihx RC2014_The_Queen_s_Footsteps
cp RC2014queens3.ihx RC2014_The_Queen_s_Footsteps

rm  RC2014_Queens.zip
zip -r RC2014_Queens.zip RC2014_The_Queen_s_Footsteps


cp RC2014_Queens.zip $ditdir
