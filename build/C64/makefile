cc65_options = -O -Cl
cc65_target  = -t c64 -C c64_altfont.cfg -D C64 -D ALTFONT
#cc65_target  = -t c64 -D C64


all: c64

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c



part1: queens1_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s
	cl65 $(cc65_target) $(cc65_options)  -DCONFIG_FILENAME=\"config1.h\" queens1_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s -o C64-tqf1.prg

part2: queens2_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s
	cl65 $(cc65_target) $(cc65_options)  -DCONFIG_FILENAME=\"config2.h\" queens2_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s -o C64-tqf2.prg

part3: queens3_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s
	cl65 $(cc65_target) $(cc65_options)  -DCONFIG_FILENAME=\"config3.h\" queens3_no_UTF8.c inout.c loadsave.c newfont/artnouveau-charset.s -o C64-tqf3.prg
	


c64: part1 part2 part3
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx 4108 -t 64 C64-tqf1.prg -o queens-64-1.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx 4108 -t 64 C64-tqf2.prg -o queens-64-2.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx 4108 -t 64 C64-tqf3.prg -o queens-64-3.prg


clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o C64-tqf1.prg  queens-64.prg