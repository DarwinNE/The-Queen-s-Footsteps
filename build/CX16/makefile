cc65_options = -Or 
cc65_target  = -t cx16 -D CX16

all: cx16

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c



part1: queens1_no_UTF8.c inout.c loadsave.c commanderX16.c
	/Applications/Emulators/x16emu_mac-r30/cc65/bin/cl65  -DCONFIG_FILENAME=\"config1.h\" $(cc65_options) $(cc65_target) queens1_no_UTF8.c inout.c loadsave.c commanderX16.c -o TQF1.PRG

part2: queens2_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config2.h\" $(cc65_options) $(cc65_target) queens2_no_UTF8.c inout.c loadsave.c commanderX16.c -o TQF2.PRG

part3: queens3_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config3.h\" $(cc65_options) $(cc65_target) queens3_no_UTF8.c inout.c loadsave.c commanderX16.c -o TQF3.PRG
 

cx16: part1 part2 part3

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o TQF1.PRG TQF2.PRG TQF3.PRG