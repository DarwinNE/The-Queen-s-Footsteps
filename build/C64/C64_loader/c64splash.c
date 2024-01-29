#include<stdio.h>
#include<conio.h>

#define SCREEN_BORDER 53280U

#define BASE 0xE000U
#define COLOR_MEMA 0xCC00U
#define COLOR_MEMB 0xD800U


#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))

extern const unsigned char screen[];
extern const unsigned char colora[];
extern const unsigned char colorb[];
extern const unsigned char border;
extern const unsigned char bg;

extern void doload(void);
extern void choice(void);
extern void doload(void);


/** Switch on the HGR monochrome graphic mode.
*/
void graphics_hires(void)
{
    POKE (56578U, PEEK(56578U) | 3);  // Select memory bank for VIC-II
    POKE (56576U, 0x00);
    POKE (53270U, PEEK(53270U) | 16); // Select multicolor mode
    POKE (53272U, 0x38);
    POKE (53265U, 0x33+8);
}

void copy_screen(void)
{
    unsigned int i;

    POKE(SCREEN_BORDER,border);
    POKE(SCREEN_BORDER+1,bg);
    for(i=0; i<40*25;++i) {
        POKE(COLOR_MEMA+i, colora[i]);
        POKE(COLOR_MEMB+i, colorb[i]);
    }
    for(i=0; i<8000;++i) {
        POKE(BASE+i, screen[i]);
    }
}

int main(void)
{
    choice();
    clrscr();
    copy_screen();
    graphics_hires();
    doload();
    return 0;
}