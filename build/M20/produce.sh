#!/bin/bash

. ../config.sh

$m20command M20_Queens.img rm splash.cpr
$m20command M20_Queens.img rm q1.cmd
$m20command M20_Queens.img rm q2.cmd
$m20command M20_Queens.img rm q3.cmd

$m20command M20_Queens.img put q1.cmd
$m20command M20_Queens.img put q2.cmd
$m20command M20_Queens.img put q3.cmd

$m20command M20_Queens.img put M20splash/splash.cpr

rm  M20_Queens.zip
zip -r M20_Queens.zip M20_Queens.img
cp M20_Queens.zip $ditdir