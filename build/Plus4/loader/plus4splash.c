#include<stdio.h>

#define SCREEN_BORDER 0xFF19U

#define BASE      0x8000U
#define COLOR_MEM 0x7800U
#define LUMA_MEM  0xD800U
#define COL1_ADD  0xFF15U
#define COL2_ADD  0xFF16U


#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))

extern const unsigned char screen[];
extern const unsigned char color[];
extern const unsigned char luma[];
extern const unsigned char border;
extern const unsigned char bg1;
extern const unsigned char bg2;


extern void doload(void);


/** Switch on the HGR monochrome graphic mode.
*/
void graphics_hires(void)
{
    POKE (0xFF06,PEEK(0xFF06)|32);  // Select bitmap mode
    POKE (0xFF07,PEEK(0xFF07)|16);  // Select multicolor mode

    POKE (0xFF12,0x20);      // Set location of bit map
    POKE (0xFF14,0x78);      // Set location of luminance/color memory
}

void copy_screen(void)
{
    unsigned int i;
    POKE(COL1_ADD, bg1);
    POKE(COL2_ADD, bg2);
    POKE(SCREEN_BORDER,border);

    for(i=0; i<40*25;++i) {
        POKE(COLOR_MEM+i, luma[i]);
        POKE(COLOR_MEM+i+1024, color[i]);
    }
    for(i=0; i<8000;++i) {
        POKE(BASE+i, screen[i]);
    }
}

int main(void)
{
    copy_screen();
    graphics_hires();

    asm("   jmp _doload");
    return 0;
}