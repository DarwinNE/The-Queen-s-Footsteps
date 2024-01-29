all: plus4

queens_no_UTF8.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c -m -c -s -d -n -w ../../aws_sources/all_parts/queens_complete.aws queens_no_UTF8.c

plus4: queens_no_UTF8.c
	cl65 -Or -t plus4 -D PLUS4 queens_no_UTF8.c inout.c loadsave.c -o p4-q.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 4 p4-q.prg -o p4-queens.prg


clean:
	rm config.h queens_no_UTF8.c *.o p4-q.prg p4-queens.prg