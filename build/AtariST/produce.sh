#!/bin/bash

. ../config.sh

rm  AtariST_Queens.zip

cp ../readme.txt .

echo "WARNING: the file the_queens_footsteps.st must have been manually updated."

zip -r AtariST_Queens.zip tqf40.tos tqf80.tos readme.txt notes_AtariST.txt the_queens_footsteps.st

cp AtariST_Queens.zip $ditdir
