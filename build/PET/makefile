cc65_options = -O -Cl
cc65_target  = -t pet

all: pet

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c



part1: queens1_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config1.h\" $(cc65_options) $(cc65_target) -D PET   queens1_no_UTF8.c inout.c loadsave.c -o PET80/queens1.prg
	cl65 -DCONFIG_FILENAME=\"config1.h\" $(cc65_options) $(cc65_target) -D PET40 queens1_no_UTF8.c inout.c loadsave.c -o PET40/queens1.prg


part2: queens2_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config2.h\" $(cc65_options) $(cc65_target) -D PET   queens2_no_UTF8.c inout.c loadsave.c -o PET80/queens2.prg
	cl65 -DCONFIG_FILENAME=\"config2.h\" $(cc65_options) $(cc65_target) -D PET40 queens2_no_UTF8.c inout.c loadsave.c -o PET40/queens2.prg

part3: queens3_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config3.h\" $(cc65_options) $(cc65_target) -D PET   queens3_no_UTF8.c inout.c loadsave.c -o PET80/queens3.prg
	cl65 -DCONFIG_FILENAME=\"config3.h\" $(cc65_options) $(cc65_target) -D PET40 queens3_no_UTF8.c inout.c loadsave.c -o PET40/queens3.prg
 

pet: part1 part2 part3

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o PET40/*.prg PET80/*.prg