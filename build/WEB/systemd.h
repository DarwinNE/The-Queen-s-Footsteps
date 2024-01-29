#ifndef __SYSTEMDEF_H__
#define __SYSTEMDEF_H__

/*  This file shows an example of how to tailor the different macros so that
    the program can be compiled on modern machines (ANSI terminal) with gcc,
    as well as on vintage Commodores by using Cc65 and many Z80 machines with
    Z88dk.

    Code should be self explicative. For exemple C128 option is active, the
    chunk of #define for the C128 is selected

    NOTE: choose all buffer sizes less than 256.

    inputtxt is called just before the prompt

    evidence1 is called just before writing the name of the current room.

    evidence2 is called just before the game title and the list of objects
        available in a certain room.

    evidence3 is called just before writing the directions allowed.
    
    CV_IS_A_FUNCTION is a macro that if defined makes sort that a function is
        called to check a thing like "verb==v". With some compilers it may be
        an advantage (e.g. cc65) in terms of size, while it's not the case
        for other compilers (e.f. Z88dk).
*/

#include <time.h>
#include "terminal.h"

#define BUFFERSIZE 255
#define B_SIZE 240

#define waitscreen()

#define waitkey() a_waitkey()

#define inputtxt()      a_puts("<span class='inputtxt'>")
#define end_inputtxt()  a_puts("</span>")

#define evidence1()     a_puts("<span class='evidence1'>")
#define end_evidence1() a_puts("</span>")

#define evidence2()     a_puts("<span class='evidence2'>")
#define end_evidence2() a_puts("</span>")

#define evidence3()     a_puts("<span class='evidence3'>")
#define end_evidence3() a_puts("</span>")

#define cls()

#define normaltxt()
#define tab()
#define wait1s()    {unsigned int retTime = time(0) + 1;while (time(0) < \
    retTime);}
#define init_term()
#define leave()

#define PUTC(c) a_putc((c))
#define PUTS(s) a_puts((s))
#define GETS(buffer, size) a_gets((buffer),(size));






#define EFFSHORTINDEX unsigned char
#define SHIFTPETSCII
#define LOAD PUTS("Loading is not supported on this platform.")
#define SAVE PUTS("Saving is not supported on this platform.")
#define FASTCALL

#endif
