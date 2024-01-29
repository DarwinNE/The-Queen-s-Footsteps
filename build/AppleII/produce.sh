#!/bin/bash

. ../config.sh

# java -jar $acjarfile -dos140 The_Queen_s_Footsteps.dsk
# blank.dsk contains DOS 3.3 in the boot sectors.
cp blank.dsk The_Queen_s_Footsteps.dsk
java -jar $acjarfile -p  The_Queen_s_Footsteps.dsk HELLO A < AppleII_The_Queen_s_Footsteps/HELLO
java -jar $acjarfile -as The_Queen_s_Footsteps.dsk queens1 < AppleII_The_Queen_s_Footsteps/queens1
java -jar $acjarfile -as The_Queen_s_Footsteps.dsk queens2 < AppleII_The_Queen_s_Footsteps/queens2
java -jar $acjarfile -as The_Queen_s_Footsteps.dsk queens3 < AppleII_The_Queen_s_Footsteps/queens3


rm  AppleII_Queens.zip
zip -r AppleII_Queens.zip The_Queen_s_Footsteps.dsk
cp AppleII_Queens.zip $ditdir