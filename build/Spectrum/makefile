all: zx

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

part1: queens1_no_UTF8.c inout.c loadsave.c
	zcc +zx -m -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" -clib=ansi -lndos -create-app queens1_no_UTF8.c inout.c loadsave.c -o 48K/ZXqueens1 -Cz--screen -Czspectrum_splash.scr
	# The -lp3 option instead of -lndos allows to load and save on the +3
	zcc +zx -DPLUS3 -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" -clib=ansi -lp3 -create-app queens1_no_UTF8.c inout.c loadsave.c -subtype=plus3 -o P3/ZXqueens1P3 -Cz--screen -Czspectrum_splash.scr
    
part2: queens2_no_UTF8.c inout.c loadsave.c
	zcc +zx -m -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" -clib=ansi -lndos -create-app queens2_no_UTF8.c inout.c loadsave.c -o 48K/ZXqueens2 -Cz--screen -Czspectrum_splash.scr
	# The -lp3 option instead of -lndos allows to load and save on the +3
	zcc +zx -DPLUS3 -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" -clib=ansi -lp3 -create-app queens2_no_UTF8.c inout.c loadsave.c -subtype=plus3 -o P3/ZXqueens2P3 -Cz--screen -Czspectrum_splash.scr
   
part3: queens3_no_UTF8.c inout.c loadsave.c
	zcc +zx -m -DCONFIG_FILENAME="\"\\\"config3.h"\"\\\" -clib=ansi -lndos -create-app queens3_no_UTF8.c inout.c loadsave.c -o 48K/ZXqueens3 -Cz--screen -Czspectrum_splash.scr
	# The -lp3 option instead of -lndos allows to load and save on the +3
	zcc +zx -DPLUS3 -DCONFIG_FILENAME="\"\\\"config3.h"\"\\\" -clib=ansi -lp3 -create-app queens3_no_UTF8.c inout.c loadsave.c -subtype=plus3 -o P3/ZXqueens3P3 -Cz--screen -Czspectrum_splash.scr

zx: part1 part2 part3 createwav

createwav:
	z88dk-appmake +zx -b 48K/ZXqueens1 --audio --screen spectrum_splash.scr -dumb -o 48K/audio/ZXqueens1.wav 
	z88dk-appmake +zx -b 48K/ZXqueens2 --audio --screen spectrum_splash.scr -dumb -o 48K/audio/ZXqueens2.wav 
	z88dk-appmake +zx -b 48K/ZXqueens3 --audio --screen spectrum_splash.scr -dumb -o 48K/audio/ZXqueens3.wav 

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o 48K/* P3/*