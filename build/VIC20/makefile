cc65_options = -O -Cl
cc65_target  = -t vic20 -D VIC20_40c

all: vic20

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c


part1: queens1_no_UTF8.c inout.c loadsave.c vic40col.s
	cl65 $(cc65_options) $(cc65_target)  -DCONFIG_FILENAME=\"config1.h\" -C vic20-32k_exp1.cfg queens1_no_UTF8.c inout.c loadsave.c vic40col.s -o queens-vic1.prg

part2: queens2_no_UTF8.c inout.c loadsave.c vic40col.s
	cl65 $(cc65_options) $(cc65_target)  -DCONFIG_FILENAME=\"config2.h\" -C vic20-32k_exp2.cfg queens2_no_UTF8.c inout.c loadsave.c vic40col.s -o queens-vic2.prg

part3: queens3_no_UTF8.c inout.c loadsave.c vic40col.s
	cl65 $(cc65_options) $(cc65_target)  -DCONFIG_FILENAME=\"config3.h\" -C vic20-32k_exp3.cfg queens3_no_UTF8.c inout.c loadsave.c vic40col.s -o queens-vic3.prg

vic20: part1 part2 part3
	#/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer mem $2001,$2001 -t 52 vic-tqf1.prg -o queens-vic1.prg


clean:
	rm *.o config1.h queens1_no_UTF8.c vic-tqf1.prg config2.h queens2_no_UTF8.c vic-tqf2.prg config3.h queens3_no_UTF8.c vic-tqf3.prg