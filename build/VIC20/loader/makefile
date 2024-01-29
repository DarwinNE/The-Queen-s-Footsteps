all: vic20

vic20: vic40loader.s
	cl65 -l ll.lst -m ll.map -Ors -t vic20 -D VIC20_40c -C vic20-32k_exp.cfg vic40loader.s -o ll.prg
	/Users/davidebucci/Desktop/Synchronized/Vintage/Computing/Commodore/exomizer-3-2/src/exomizer sfx basic -t 52 ll.prg -o loader.prg

clean:
	rm *.o
