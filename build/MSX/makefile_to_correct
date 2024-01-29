aws_options  = -m -c -s -d -n -w -l -3
zcc_options = +cpm -DNOANSI -pragma-define:CLIB_DISABLE_FGETS_CURSOR=1 -lm

all: cpm

silkdust1_no_UTF8.c: ../../aws_sources/part1/silkdust1.aws
	../../../aws2c  $(aws_options) -f config1.h ../../aws_sources/part1/silkdust1.aws silkdust1_no_UTF8.c

silkdust2_no_UTF8.c: ../../aws_sources/part2/silkdust2.aws
	../../../aws2c $(aws_options)  -f config2.h ../../aws_sources/part2/silkdust2.aws silkdust2_no_UTF8.c

silkdust34_no_UTF8.c: ../../aws_sources/part34/silkdust34.aws
	../../../aws2c $(aws_options) -f config34.h ../../aws_sources/part34/silkdust34.aws silkdust34_no_UTF8.c

cpm: part1 part2 part34

part1: silkdust1_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config1.h"\"\\\" silkdust1_no_UTF8.c inout.c loadsave.c -o sd1.com

part2: silkdust2_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config2.h"\"\\\" silkdust2_no_UTF8.c inout.c loadsave.c -o sd2.com

part34: silkdust34_no_UTF8.c inout.c loadsave.c
	zcc $(zcc_options) -DCONFIG_FILENAME="\"\\\"config34.h"\"\\\" silkdust34_no_UTF8.c inout.c loadsave.c -o sd34.com


clean:
	rm *.o  config1.h config34.h silkdust1_no_UTF8.c config2.h silkdust2_no_UTF8.c silkdust34_no_UTF8.c sd1.com sd2.com sd34.com