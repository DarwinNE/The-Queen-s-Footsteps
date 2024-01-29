/* load a bmp file and display it
 * by Davide Bucci and Christian Groessler
 * 2007 - 2020
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/pcos.h>
#include "systemd.h"

#define CH_CODE 0xD6
typedef unsigned char byte;

void set80col(void);

struct bmp_info {
    unsigned long offset; /* bfOffBits */
    unsigned int width;   /* biWidth */
    unsigned int height;  /* biHeight */
};

#define LOAD_FILE "splash.cpr"
#define SCREENBUFSIZE 16384

#define SCREEN_WIDTH    512
#define SCREEN_HEIGHT   256
#define SCREEN_SIZE     (512 / 16 * 256)   /* words */
#define a_abs(a) ((a)>0 ? (a):(-a))
#define a_max(a,b) (((a)>(b))? (a):(b))
#define a_sign(a) ((a)>0 ? 1 : ((a)==0 ? 0 : (-1)))
#define TRUE -1
#define FALSE 0

unsigned short *screen = (unsigned short *)0x3000000;  /* segment #3 */

void m20_putc(char c)
{
    char bmp_hdr[2];
    if(c=='\n'||c=='\r') {
        _pcos_crlf();
    } else {
        bmp_hdr[0]=c;
        bmp_hdr[1]='\0';
        PUTS(bmp_hdr);
    }
}

char get_byte(FILE* fin)
{
    static byte c;
    static int l_count;

    if(l_count==0) {
        c=getc(fin);
        if(c==CH_CODE) {
            l_count=getc(fin)-1;
            return c = getc(fin);
        }
        return c;
    } else {
        --l_count;
        return c;
    }
}

void wait_key(void)
{
    unsigned char key;

    /* wait for a key press */
    _pcos_getbyte(DID_CONSOLE, &key);
}

long int get_32bit(FILE *fin)
{
    return getc(fin) | (getc(fin) << 8) | 
        ((unsigned long)getc(fin) << 16) | ((unsigned long)getc(fin) << 24);
}

void showsplash(void)
{
    unsigned int ix, iy, ep1, ep2, xadj;
    unsigned short *screen_buf;
    struct bmp_info file_info;  /* cache image data from file format check */

    FILE *fin;

    /* allocate buffer to prepare image in memory */
    screen_buf = malloc(SCREENBUFSIZE);
    if (! screen_buf) {
        return;
    }
    memset(screen_buf, 0, SCREENBUFSIZE);

    /* open picture file */
    fin = fopen(LOAD_FILE, "rb");
    if (! fin) {
        free(screen_buf);
        return;
    }

    file_info.width = get_32bit(fin);
    file_info.height = get_32bit(fin);
    

    /* create the screen image */
    iy = (255 - (256 - file_info.height)) * 32;
    xadj = (256 - file_info.width / 2) / 16;
    while (--file_info.height) {
        for (ix = 0; ix < (file_info.width+16) / 8; ix+=2) {
            ep1 = get_byte(fin);
            ep2 = get_byte(fin);
            *(screen_buf + iy + xadj + (ix >> 1)) = (ep2 | (ep1 << 8));
        }
        iy -= 32;
    }

    memcpy(screen, screen_buf, SCREENBUFSIZE);  /* display picture */

    fclose(fin);
    free(screen_buf);

    wait_key();

    set80col();
    _pcos_cls();  /* clear screen */

    return;
}
