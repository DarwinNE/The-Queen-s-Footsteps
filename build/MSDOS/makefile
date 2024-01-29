all: msdos

queens_no_UTF8.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c -m -c -s -d -n ../../aws_sources/all_parts/queens_complete.aws queens_no_UTF8.c

msdos: queens_no_UTF8.c inout.c loadsave.c
	cp queens_no_UTF8.c ~/oldgames/TURBOC3/QUEENSR
	cp config.h ~/oldgames/TURBOC3/QUEENSR
	cp systemd.h ~/oldgames/TURBOC3/QUEENSR
	cp aws.h ~/oldgames/TURBOC3/QUEENSR
	cp inout.c ~/oldgames/TURBOC3/QUEENSR
	cp inout.h ~/oldgames/TURBOC3/QUEENSR
	cp loadsave.c ~/oldgames/TURBOC3/QUEENSR
	cp loadsave.h ~/oldgames/TURBOC3/QUEENSR
	/Applications/DosBox/DOSBox.app/Contents/MacOS/DOSBox -exit -c queensr.bat 
	cat ~/oldgames/TURBOC3/QUEENSR/errors.txt
	cp ~/oldgames/TURBOC3/QUEENSR/QUEENS.EXE .
	cp ~/oldgames/TURBOC3/QUEENSR/QUEENSN.EXE .



clean:
	rm config.h queens_no_UTF8.c *.o QUEENS.EXE QUEENSN.EXE
