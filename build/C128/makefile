cc65_options = -O -Cl
cc65_target  = -t c128 -D C128

all: c128

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c



part1: queens1_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c
	cl65 -DCONFIG_FILENAME=\"config1.h\" $(cc65_options) $(cc65_target) -D ALTSPLASH queens1_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c -o C128-tqf1.prg

part2: queens2_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c
	cl65 -DCONFIG_FILENAME=\"config2.h\" $(cc65_options) $(cc65_target) -D ALTSPLASH queens2_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c -o C128-tqf2.prg

part3: queens3_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c
	cl65 -DCONFIG_FILENAME=\"config3.h\" $(cc65_options) $(cc65_target) -D ALTSPLASH queens3_no_UTF8.c inout.c loadsave.c C128_splash/c128sp.c -o C128-tqf3.prg
 

c128: part1 part2 part3
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 128 C128-tqf1.prg -o C128-queen1.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 128 C128-tqf2.prg -o C128-queen2.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 128 C128-tqf3.prg -o C128-queen3.prg

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o C128-queen1.prg C128-queen2.prg C128-queen3.prg C128_tqf1.prg C128_tqf2.prg C128_tqf3.prg