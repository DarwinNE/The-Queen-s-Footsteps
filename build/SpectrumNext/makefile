aws_options = -m -c -s -d -n -w -l -3
zcc_options = +zxn -lesxdos -DSPECTRUMNEXT -lm -clib=classic -create-app -subtype=nex

.PHONY: part1 part2 part34 all next clean


all: next

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c $(aws_options) -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c $(aws_options) -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c $(aws_options) -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

part1: queens1_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" queens1_no_UTF8.c inout.c loadsave.c -o queens1
    
part2: queens2_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" queens2_no_UTF8.c inout.c loadsave.c -o queens2

part3: queens3_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config3.h"\"\\\" queens3_no_UTF8.c inout.c loadsave.c -o queens3

next: part1 part2 part3

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o rm queens1 queens1.nex queens2 queens2.nex queens3 queens3.nex queens*.bin