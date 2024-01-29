# path to RETRO68
RETRO68=/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Apple/Retro68/Retro68-build/toolchain

68kCONSOLEDIR=/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Apple/Retro68/Retro68/Console/retro

68kPREFIX=$(RETRO68)/m68k-apple-macos
68kCC=$(RETRO68)/bin/m68k-apple-macos-gcc
68kCXX=$(RETRO68)/bin/m68k-apple-macos-g++
68kREZ=$(RETRO68)/bin/Rez
68kLDFLAGS= $(68kCONSOLEDIR)/libConsole.a -lretrocrt -Wl,-gc-sections -Wl,--mac-strip-macsbug
68kRINCLUDES=$(68kPREFIX)/RIncludes
68kREZFLAGS=-I$(68kRINCLUDES)

all: 68kmac

queens_complete_no_UTF8.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c -m -c -s -d -n -w ../../aws_sources/all_parts/queens_complete.aws queens_complete_no_UTF8.c


68kmac: queens_complete_no_UTF8.c inout.c  loadsave.c
	$(68kCC) -DD68kmac -Wno-narrowing  queens_complete_no_UTF8.c -c -o queens_complete_no_UTF8.o
	$(68kCC) -DD68kmac -Wno-narrowing  inout.c -c -o inout.o
	$(68kCC) -DD68kmac -Wno-narrowing  loadsave.c -c -o loadsave.o
	$(68kCC) -DD68kmac -Wno-narrowing  SplashWindow.c -c -o  SplashWindow.o
	$(68kCXX) -DD68kmac -Wno-narrowing  queens_complete_no_UTF8.o inout.o SplashWindow.o loadsave.o -Wwrite-strings -o queens.code.bin $(68kLDFLAGS)	# C++ used for linking because RetroConsole needs it
	$(68kREZ) $(68kREZFLAGS) \
		--copy "queens.code.bin" --copy Mucha3.pict.bin --copy icons2.bin\
		"$(68kRINCLUDES)/Retro68APPL.r" SplashWindow.r \
		-t "APPL" -c "QuEe" \
		-o "The Queen's Footsteps.bin" --cc "The Queen's Footsteps.APPL" --cc "The Queen's Footsteps.dsk"

clean:
	rm *.o queens_complete_no_UTF8.c config.h "The Queen's Footsteps.bin"