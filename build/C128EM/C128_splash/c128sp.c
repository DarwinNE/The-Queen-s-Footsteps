/* load a bmp file and display it
 * by Davide Bucci and Christian Groessler
 * 2007 - 2020
 */

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <c128.h>
#include "c128sp.h"

#define LOAD_FILE "splash.cpr"
#define CH_CODE 0x2A

#define SCREENBUFSIZE 16384

#define SCREEN_WIDTH    512
#define SCREEN_HEIGHT   256
#define SCREEN_SIZE     (512 / 16 * 256)   /* words */
#define a_abs(a) ((a)>0 ? (a):(-a))
#define a_max(a,b) (((a)>(b))? (a):(b))
#define a_sign(a) ((a)>0 ? 1 : ((a)==0 ? 0 : (-1)))
#define TRUE -1
#define FALSE 0

#define VDC_REGISTERN  0xD600
#define VDC_DATA       0xD601

typedef unsigned char byte;

byte bmp_hdr[8];
byte save_VDC[37];

unsigned char nice_message[80] =
"   Type `RETURN' or `SPACE' after loading..     ";


void write_VDC(byte reg, byte data)
{
    (*(byte *)VDC_REGISTERN)=reg;
    asm("@wait: bit $D600");
    asm("       bpl @wait");
    (*(byte *)VDC_DATA)=data;
}

byte read_VDC(byte reg)
{
    (*(byte *)VDC_REGISTERN)=reg;
    asm("@wait: bit $D600");
    asm("       bpl @wait");
    return (*(byte *)VDC_DATA);
}

#define BUFSIZE 1024
byte buffer[BUFSIZE];
int posb;
int readch;
FILE *fin;

int __fastcall__ b_read(void)
{
    if(posb==readch) {
        fread(buffer, BUFSIZE, 1, fin);
        readch=BUFSIZE;
        posb=0;
    }
    if(posb<readch) {
        return buffer[posb++];
    } else {
        return -1;
    }
}

byte __fastcall__ get_byte(void)
{
    static byte c;
    static int l_count;

    if(l_count==0) {
        c=b_read();
        if(c==CH_CODE) {
            l_count=b_read()-1;
            return c = b_read();
        }
        return c;
    } else {
        --l_count;
        return c;
    }
}

int readfile(void)
{
    int st;
    unsigned int addr, width, height, w8;
    unsigned int ix, ep1, oep, xadj, count;

    fin = fopen(LOAD_FILE, "rb");
    if (fin==NULL)
        return 1;

    for(st=0;st<8;++st)
        bmp_hdr[st]=b_read();

    /* check resolution */
    width = bmp_hdr[0] | (bmp_hdr[1] << 8) | 
        ((unsigned long)bmp_hdr[2] << 16) | ((unsigned long)bmp_hdr[3] << 24);
    height = bmp_hdr[4] | (bmp_hdr[5] << 8) | 
        ((unsigned long)bmp_hdr[6] << 16) | ((unsigned long)bmp_hdr[7] << 24);

    if (width > 640 || height > 256) return 0;

    xadj = (640/2 - width / 2) / 8;

    addr=(((unsigned long)640*200)/8+xadj);
    w8 = width / 8;
    count=0;
    while (height--) {
        //write_VDC(18,(addr&0x3F00)>>8);    // HI
        write_VDC(18,(addr&0xFF00)>>8);    // HI
        write_VDC(19,addr&0x00FF);         // LO
        for (ix = 0; ix < w8; ++ix) {
            ep1 = get_byte();
            if(oep==ep1)
                ++count;
            else {
                write_VDC(31, oep); // DATA
                oep=ep1;
                if(count) {
                    write_VDC(30, count);
                    count=0;
                }
            }
        }
        write_VDC(31, oep); // DATA
        if(count) {
            write_VDC(30, count);
            count=0;
        }
        if(kbhit()!=0)
            break;
        addr-=80;
    }


    fclose(fin);

    return 0;
}

void gr_mode(void)
{
    byte c,i;
    int iy;
   
    for(i=0; i<37; ++i)
        save_VDC[i]=read_VDC(i);
    
    c=read_VDC(25);
    write_VDC(25, 128+(c & 0x0F));  // Set bitmap mode
    write_VDC(26,14*16+0);

    write_VDC(18,0);
    write_VDC(19,0);
    for(iy=0;iy<16383/256;++iy) {
        write_VDC(31,0);
        write_VDC(30,255);
    }
}

void back_to_txt(void)
{
    byte i;
    for(i=0;i<16383/256;++i) {
        write_VDC(31,0);
        write_VDC(30,255);
    }
    for(i=0; i<37; ++i)
        write_VDC(i,save_VDC[i]);
    asm("jsr $ce0c");
    asm("lda #$93");     // Clear the screen
    asm("jsr $ffd2");

}

void showsplash(void)
{
    gr_mode();
    if(readfile()==0)
        cgetc();
    back_to_txt();
}

#ifdef SP_TEST

#define switch80col "\x1Bx\x0E"
int main(void)
{
    fast();
    fputs("Start",stdout);
    //fputs(switch80col,stdout);
    showsplash();
    return 0;
}
#endif
