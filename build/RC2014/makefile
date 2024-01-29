all: rc2014

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

rc2014: part1 part2 part3

part1: queens1_no_UTF8.c inout.c loadsave.c
	zcc +rc2014 -DRC2014 -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" -subtype=basic -O2 --opt-code-speed=none -clib=sdcc_iy queens1_no_UTF8.c inout.c -o RC2014queens1 -create-app 

part2: queens2_no_UTF8.c inout.c loadsave.c
	zcc +rc2014 -DRC2014 -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" -subtype=basic -O2 --opt-code-speed=none -clib=sdcc_iy queens2_no_UTF8.c inout.c -o RC2014queens2 -create-app 

part3: queens3_no_UTF8.c inout.c loadsave.c
	zcc +rc2014 -DRC2014 -DCONFIG_FILENAME="\"\\\"config3.h"\"\\\" -subtype=basic -O2 --opt-code-speed=none -clib=sdcc_iy queens3_no_UTF8.c inout.c -o RC2014queens3 -create-app 


clean:
	rm *.o queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c config*.h RC2014queens*