#include<stdio.h>

#define SCREEN_BORDER 53280U

#define BASE 12288U


#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))

extern const unsigned char charset[];


/** Switch on the HGR monochrome graphic mode.
*/
void alt_set(void)
{
    POKE (53272U, PEEK(53272U) & 240 | 12) ;
    // poke 53272,(peek(53272)and 240)+2
}

void copy_char(void)
{
    unsigned int i;

    for(i=0; i<2048;++i) {
        POKE(BASE+i, charset[i]);
    }
}

int main(void)
{
    copy_char();
    alt_set();
    return 0;
}