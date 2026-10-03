#include<stdio.h>
#include <errno.h>
#include <string.h>

struct bmp_info {
    unsigned long offset; /* bfOffBits */
    unsigned int width;   /* biWidth */
    unsigned int height;  /* biHeight */
};

#define LOAD_FILE  "splash.bmp"
#define WRITE_FILE "splash.cpr"
#define CH_CODE 0x2A

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

struct bmp_info file_info;  /* cache image data from file format check */
byte bmp_hdr[64];

unsigned char nice_message[80] =
"   Type `RETURN' or `SPACE' after loading..     ";

/* check file for correct bmp format (resolution, etc.) */

int bmp_format_ok(char *filename)
{
    size_t numr;
    unsigned long width, height;
    FILE *f;
    printf("Reading the header.\n");

    f = fopen(filename, "rb");
    if (! f) {
        printf("Can't open file %s\n", filename);
        return 0;
    } 

    /* read the 1st 64 bytes and look at them */
    for(numr=0; numr<64;++numr)
        bmp_hdr[numr]=getc(f);

    printf("Read %d bytes\n",(int)numr);
    fclose(f);
    if (! numr) {
        printf("Can't read header.");
        return 0;
    }
    printf("Check header: ");
    /* check header */
    if (bmp_hdr[0] != 'B' || bmp_hdr[1] != 'M') {
        printf("Incorrect header: not a BMP file.");
        return 0;
    }
    printf("OK\nCheck planes: ");

    /* check planes */
    if ((bmp_hdr[26] | (bmp_hdr[27] << 8)) != 1) {
        printf("Incorrect header: not a single plane.");
        return 0;
    }
    printf("OK\nCheck BW: ");

    /* check bits per pixel */
    if ((bmp_hdr[28] | (bmp_hdr[29] << 8)) != 1) {
        printf("Incorrect header: not a B/W file.");
        return 0;
    }
    printf("OK\nCheck resolution: ");
    /* check resolution */
    width = (unsigned long)bmp_hdr[18] | ((unsigned long)bmp_hdr[19] << 8) | 
        ((unsigned long)bmp_hdr[20] << 16) | ((unsigned long)bmp_hdr[21] << 24);
    
    height = (unsigned long)bmp_hdr[22] | ((unsigned long)bmp_hdr[23] << 8) | 
        ((unsigned long)bmp_hdr[24] << 16) | ((unsigned long)bmp_hdr[25] << 24);

    if ((unsigned int)width > 512 || (unsigned int)height > 256) {
        printf("Image size too big: %lu x %lu\n",width,height);
        return 0;
    }
    file_info.width = (unsigned int)width;
    file_info.height = (unsigned int)height;

    /* now variable 'width' is misused to get offset */
    width = bmp_hdr[10] | (bmp_hdr[11] << 8) | 
        ((unsigned long)bmp_hdr[12] << 16) | ((unsigned long)bmp_hdr[13] << 24);
    file_info.offset = width;

    fclose(f);
    return 1;
}

int readbmp(void)
{
    int ep1;
    int oep;
    int count;
    int ix, height, width, st;
    int stats[256];
    
    for(ix=0;ix<256;++ix)
        stats[ix]=0;

    FILE *fin;
    FILE *fout;
    printf("Reading image, please wait...");

    if(bmp_format_ok(LOAD_FILE)==0) {
        printf("Can't load image. Incorrect file format\n");
        return 1;
    }

    fin = fopen(LOAD_FILE, "rb");
    fout = fopen(WRITE_FILE, "wb");

    if (! fin || ! fout) {
        printf("cannot open '%s': %s\n", LOAD_FILE, strerror(errno));
        return 1;
    }
    // Width
    putc(bmp_hdr[18], fout);
    putc(bmp_hdr[19], fout);
    putc(bmp_hdr[20], fout);
    putc(bmp_hdr[21], fout);
    // Height
    putc(bmp_hdr[22], fout);
    putc(bmp_hdr[23], fout);
    putc(bmp_hdr[24], fout);
    putc(bmp_hdr[25], fout);

    count=0;
    for(st=0;st<file_info.offset;++st)
        getc(fin);

    /* create the screen image */
    height = file_info.height;
    width = file_info.width;
    printf("Image size: %d x %d\n",width,height);
    count=1;
    while (height--) {
        for (ix = 0; ix < width / 8; ix++) {
            ep1 = getc(fin);
            ++stats[(unsigned char)ep1];
            if(ep1==oep && count<255) {
                ++count;
            } else if(count>3 || (oep == CH_CODE)) {
                //printf("repetition: %d 0x%x\n",count, (unsigned char)oep);
                putc(CH_CODE, fout);
                putc(count, fout);
                count=1;
                putc(oep, fout);
            } else {
                while(count>=1) {
                    putc(oep, fout);
                    --count;
                }
                count=1;
            }
            oep=ep1;
        }
    }
    if(count>3 || (oep == CH_CODE)) {
        putc(CH_CODE, fout);
        putc(count, fout);
        count=1;
        putc(oep, fout);
    } else {
        while(count>=1) {
            putc(oep, fout);
            --count;
        }
        count=1;
    }
    fclose(fin);
    fclose(fout);

    count=32768;
    for(ix=0;ix<256;++ix)
        if(count>stats[ix]) {
            count=stats[ix];
            ep1=ix;
        }
        
    printf("One of less used chars: 0x%x (%d times)\n",ep1, count);
    return 0;
}


int main(int argc, char** argv)
{
    readbmp();
    return 0;
}