all: amiga

queen_no_UTF8.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c -m -c -s -d -n -w ../../aws_sources/all_parts/queens_complete.aws queen_no_UTF8.c

amiga: queen_no_UTF8.c inout.c loadsave.c
	# I don't understand why the compile command fails if put here directly!
	./compile_script.sh

clean:
	rm config.h queen_no_UTF8.c *.o AMIqueen
