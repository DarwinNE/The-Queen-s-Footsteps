cc65_options = -O -Cl
cc65_target  = -t apple2 -D NOANSI -D NCOL=40
output_dir = AppleII_The_Queen_s_Footsteps

all: appleii

queens1_no_UTF8.c: ../../aws_sources/part1/queens1.aws
	../../../aws2c -m -c -s -d -n -w -f config1.h ../../aws_sources/part1/queens1.aws queens1_no_UTF8.c

queens2_no_UTF8.c: ../../aws_sources/part2/queens2.aws
	../../../aws2c -m -c -s -d -n -w -f config2.h ../../aws_sources/part2/queens2.aws queens2_no_UTF8.c

queens3_no_UTF8.c: ../../aws_sources/part34/queens3.aws
	../../../aws2c -m -c -s -d -n -w -f config3.h ../../aws_sources/part34/queens3.aws queens3_no_UTF8.c



part1: queens1_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config1.h\" $(cc65_options) $(cc65_target) queens1_no_UTF8.c inout.c loadsave.c -o $(output_dir)/queens1

part2: queens2_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config2.h\" $(cc65_options) $(cc65_target) queens2_no_UTF8.c inout.c loadsave.c -o $(output_dir)/queens2

part3: queens3_no_UTF8.c inout.c loadsave.c
	cl65 -DCONFIG_FILENAME=\"config3.h\" $(cc65_options) $(cc65_target) queens3_no_UTF8.c inout.c loadsave.c -o $(output_dir)/queens3

appleii: part1 part2 part3
	echo "done"

clean:
	rm config1.h config2.h config3.h queens1_no_UTF8.c queens2_no_UTF8.c queens3_no_UTF8.c *.o $(output_dir)/queens1 $(output_dir)/queens2 $(output_dir)/queens3