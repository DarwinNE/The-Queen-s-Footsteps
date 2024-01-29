


#include <graphics.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <arch/z88/z88.h>


// Minimal Code for generation an application header
#include <arch/z88/dor.h>
#define APP_NAME "copyscreen"
#define APP_KEY 'c'
#include <arch/z88/application.h>


extern int  z88_open_map(int width) __z88dk_fastcall;
extern int  z88_close_map(void);
extern int  z88_clear_map(void);
extern void z88_copy_zx0_char_screen_to_map(void *data) __z88dk_fastcall;


extern void *char_screen;


int main() {
    z88_open_map(255);	// Width of the screen
    cputs("Showing screen by character\n");
    z88_copy_zx0_char_screen_to_map(&char_screen);
    cputs("Press any key to clear the graphics\n");
    fgetc_cons();
    z88_clear_map();
    cputs("The graphics should not be visible");
    fgetc_cons();
    z88_close_map();
}


