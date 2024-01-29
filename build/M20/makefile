gcc_options = -D M20 -DALTSPLASH -Os
gcc_target  = 

all: m20

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -3 -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -3 -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -3 -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c

part1: queens1_no_UTF8.c inout.c loadsave.c
	z8k-pcos-gcc  $(gcc_target) $(gcc_options) -DCONFIG_FILENAME=\"config1.h\" queens1_no_UTF8.c inout.c loadsave.c m20sp.c set80col.s -o q1.cmd

part2: queens2_no_UTF8.c inout.c loadsave.c
	z8k-pcos-gcc  $(gcc_target) $(gcc_options) -DCONFIG_FILENAME=\"config2.h\" queens2_no_UTF8.c inout.c loadsave.c m20sp.c set80col.s -o q2.cmd
	
part3: queens3_no_UTF8.c inout.c loadsave.c
	z8k-pcos-gcc  $(gcc_target) $(gcc_options) -DCONFIG_FILENAME=\"config3.h\" queens3_no_UTF8.c inout.c loadsave.c m20sp.c set80col.s -o q3.cmd

 

m20: part1 part2 part3

clean:
	rm config1.h config2.h config3.h inout.i inout.s loadsave.i loadsave.s m20sp.i m20sp.s queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c queens1_no_UTF8.s queens2_no_UTF8.s queens3_no_UTF8.s queens1_no_UTF8.i queens2_no_UTF8.i queens3_no_UTF8.i *.o q1.cmd q2.cmd q3.cmd