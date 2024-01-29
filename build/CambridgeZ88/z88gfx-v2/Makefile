

# Select the image size
WIDTH=256
SIZE=2048

#WIDTH=128
#SIZE=1024


CFLAGS = 
LDFLAGS = -subtype=app -create-app -m

demo.bin: main.o screen.o z88gfx.o 
	zcc +z88 $(LDFLAGS) $^ -o $@


screen.o: screen.bin.zx0

%.o: %.c
	zcc +z88 $(CFLAGS) -o $@ -c $<

%.o: %.asm
	zcc +z88 $(CFLAGS) -o $@ -c $<

# Compressed char by char screen
screen.bin.zx0: screen.bin
	z88dk-zx0 screen.bin


# Char by char screen - full size it's 2048 bytes
screen.bin: screen.scr convchar
	./convchar $(WIDTH) < $^ | dd of=$@ bs=$(SIZE) count=1 skip=0


# Short C program to read in a screen in ZX screen format and output in
# char by char format
convchar: convchar.c
	$(CC) -o convchar convchar.c


clean:
	$(RM) *.o convchar screen.bin* demo.* demo_*

