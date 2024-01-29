all: modern_terminal

queens.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c -m -c -s -d -n -w ../../aws_sources/all_parts/queens_complete.aws queens.c

all_parts: queens.c inout.c loadsave.c
	gcc queens.c inout.c loadsave.c -o queens

modern_terminal: all_parts


clean:
	rm config.h queens.c queens