all: cpc

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

cpc: part1 part2 part3

part1: queens1_no_UTF8.c inout.c loadsave.c
	zcc +cpc -DCPC  -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\"  -lcpcfs -lm -subtype=dsk -create-app queens1_no_UTF8.c inout.c loadsave.c -o CPCqueen

part2: queens2_no_UTF8.c inout.c loadsave.c
	zcc +cpc -DCPC  -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\"  -lcpcfs -lm -subtype=dsk -create-app queens2_no_UTF8.c inout.c loadsave.c -o queen2

part3: queens3_no_UTF8.c inout.c loadsave.c
	zcc +cpc -DCPC  -DCONFIG_FILENAME="\"\\\"config3.h"\"\\\"  -lcpcfs -lm -subtype=dsk -create-app queens3_no_UTF8.c inout.c loadsave.c -o queen3


clean:
	rm *.o queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c config*.h CPCqueen CPCqueen.* queen2.* queen3.* queen2 queen3