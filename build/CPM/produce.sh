#!/bin/bash

. ../config.sh

rm  CPM_Queens.zip
zip -r CPM_Queens.zip CPMqns1.com CPMqns2.com CPMqns3.com
cp CPM_Queens.zip $ditdir