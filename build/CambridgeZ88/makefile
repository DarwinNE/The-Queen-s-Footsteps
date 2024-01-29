zcc_options_epr = +z88 -DZ88 -create-app -pragma-define:ansicolumns=80  z88.c -pragma-define:CRT_ORG_CODE=32768 -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm -clib=ansi -m -subtype=app
zcc_options_ins = +z88 -DZ88 -create-app -pragma-define:ansicolumns=80  z88.c -pragma-define:CRT_ORG_CODE=32768 -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm -clib=ansi -m -subtype=installer
zcc_options_bas = +z88 -DZ88 -DALTSPLASH  Z88SP.c screen.asm z88gfx.asm -clib=ansi -m 

.PHONY: part1 part2 part34 all z88

all: z88

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

part1: queens1_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"Queen's 1"\"\\\" -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" queens1_no_UTF8.c inout.c loadsave.c -o TQF1.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"Queen's 1"\"\\\" -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" queens1_no_UTF8.c inout.c loadsave.c -o TQF1.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" queens1_no_UTF8.c inout.c loadsave.c -o TQF1.BAS

part2: queens2_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"Queen's 2"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens2_no_UTF8.c inout.c loadsave.c -o TQF2.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"Queen's 2"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens2_no_UTF8.c inout.c loadsave.c -o TQF2.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens2_no_UTF8.c inout.c loadsave.c -o TQF2.BAS


part3: queens3_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options_epr) -DAPP_NAME="\"\\\"Queen's 3"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens3_no_UTF8.c inout.c loadsave.c -o TQF3.bin
	zcc $(zcc_options_ins) -DAPP_NAME="\"\\\"Queen's 3"\"\\\" -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens3_no_UTF8.c inout.c loadsave.c -o TQF3.bin
	zcc $(zcc_options_bas) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens3_no_UTF8.c inout.c loadsave.c -o TQF3.BAS


 

z88: part1 part2 part3

clean:
	rm *.62 *.63 *.map *.epr config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o *.BAS *.bin *.ap*