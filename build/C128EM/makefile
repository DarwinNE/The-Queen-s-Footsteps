aws_options  = -m -c -s -d -n -w -3 -kk -p
cc65_options = -O -Cl -t c128 -D C128 -D C128_EXT_RESOURCES

all: c128

queens_no_utf8_en.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c $(aws_options) -R res_en.lst mapfile_en.h -f config_en_nu.h $< $@

C128-tqf.prg: queens_no_utf8_en.c inout.c loadsave.c C128_splash/c128sp.c
	cl65 -DCONFIG_FILENAME=\"config_en_nu.h\" $(cc65_options) -D ALTSPLASH queens_no_utf8_en.c inout.c loadsave.c resource.c C128_splash/c128sp.c -o $@

text_en.dat: queens_no_utf8_en.c
	python ../../../utils/retro/res_packer.py res_en.lst text_en.dat

C128-queen.prg:	C128-tqf.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 128 %< -o $@
	#~/Development/exomizer/src/exomizer sfx basic -t 128 $< -o $@

c128: C128-queen.prg text_en.dat

clean:
	rm queens_no_utf8*.c config_*_nu.h *.o *.dat *.po *.map *.bin mapfile_*.h *.lst *.zip *.prg
