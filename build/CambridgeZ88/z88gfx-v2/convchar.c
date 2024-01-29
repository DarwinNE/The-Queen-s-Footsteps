
/* Convert screen to character */


#include <stdio.h>
#include <stdlib.h>

static unsigned char buf[6912];


int main(int argc, char **argv) {
    int width = 256;

    if ( argc > 1 ) {
       width = atoi(argv[1]);
    }

    fread(buf, 1, 6912, stdin);

    for ( int seg = 0; seg < 3; seg++ ) {
        unsigned char *segstart = buf + (seg * 2048);
        for ( int row = 0; row < 8 ; row++ ) {
           unsigned char *rowstart = segstart + (32 * row);
           for ( int ccol = 0; ccol < width / 8; ccol++ ) {
              unsigned char *charstart = rowstart;
              for ( int crow = 0; crow < 8; crow++ ) {
                fwrite(charstart, 1, 1, stdout);
                charstart = charstart + 256;
              }
              rowstart++;
           }
        }
    }

}
