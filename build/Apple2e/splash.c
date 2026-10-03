#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>

#include <apple2enh.h>
#include <peekpoke.h>
#include <em.h>

#define	S_80STOREOFF	0xC000
#define S_80STOREON	0xC001
#define S_WRMAINRAM	0xC004
#define S_WRCARDRAM	0xC005
#define S_CLR80VID	0xC00C
#define S_SET80VID	0xC00D
#define S_TXTCLR	0xC050
#define S_TXTSET	0xC051
#define S_MIXCLR	0xC052
#define S_TXTPAGE1	0xC054
#define S_TXTPAGE2	0xC055
#define S_HIRESOFF	0xC056
#define S_HIRES		0xC057
#define S_CLRAN3	0xC05E
#define S_SETAN3	0xC05F

//#define DHGR_MODE

#define	A_HGR_P1	0x2000
#define HGR_PAGE_SIZE	0x2000

/*** Resource code ***/
#if !defined(RES_START_PAGE)
#if defined(DHGR_MODE)
#define RES_START_PAGE	64
#else
#define RES_START_PAGE	6
#endif
#endif

#define HEADER_PAGES	8
#define RESOURCE_FILE	"TEXT.DAT"

uint8_t load_resource_file(void) {
    uint8_t chunk[EM_PAGE_SIZE];
    struct em_copy copy_params;
    size_t read_count;
    FILE *resfile;
    uint8_t current_page = RES_START_PAGE;

    resfile = fopen(RESOURCE_FILE, "rb");
    if(!resfile) return 0;

    while ((read_count = fread(chunk, 1, EM_PAGE_SIZE, resfile)) > 0) {
        copy_params.buf   = chunk;
        copy_params.offs  = 0;
        copy_params.page  = current_page++;
        copy_params.count = read_count;

        em_copyto(&copy_params);
    }

    fclose(resfile);

    return current_page - RES_START_PAGE;
}

/*** Graphics code ***/
void main_to_aux(uint16_t src_addr_s, uint16_t src_addr_e, uint16_t dest_addr) {
    uint16_t *src = (uint16_t *)0x3c;
    uint16_t *dest = (uint16_t *)0x42;

    src[0] = src_addr_s;
    src[1] = src_addr_e;
    dest[0] = dest_addr;

    asm("sec");
    asm("jsr $c311");
}

void aux_to_main(uint16_t src_addr_s, uint16_t src_addr_e, uint16_t dest_addr) {
    uint16_t *src = (uint16_t *)0x3c;
    uint16_t *dest = (uint16_t *)0x42;

    src[0] = src_addr_s;
    src[1] = src_addr_e;
    dest[0] = dest_addr;

    asm("clc");
    asm("jsr $c311");
}

void text_mode(void) {
    videomode(VIDEOMODE_40COL);
    clrscr();
}

void hgr_mode(void) {
    POKE(S_TXTCLR, 0);     // Graphics mode
    POKE(S_MIXCLR, 0);     // Full screen, remove mixed part
    POKE(S_TXTPAGE1, 0);
    POKE(S_HIRES, 0);      // Hires mode
}

void hgr_mode_off(void) {
    POKE(S_SET80VID, 0);
    POKE(S_HIRESOFF, 0);
    POKE(S_TXTSET, 0);
    POKE(S_MIXCLR, 0);
}

void dhgr_mode(void) {
    POKE(S_80STOREOFF, 0); // Use $C002-$C005 for Aux Memory, standard bank switching
    POKE(S_SET80VID, 0);   // 80 columns mode
    POKE(S_TXTCLR, 0);     // Graphics mode
    POKE(S_HIRES, 0);      // Hires mode
    POKE(S_MIXCLR, 0);     // Full screen, remove mixed part
    POKE(S_CLRAN3, 0);     // Double Hires
}

void dhgr_mode_off(void) {
    POKE(S_SET80VID, 0);
    POKE(S_CLRAN3, 0);
    POKE(S_HIRESOFF, 0);
    POKE(S_TXTSET, 0);
    POKE(S_MIXCLR, 0);
}

void v7_mono(void) {
    POKE(S_CLR80VID, 0);
    POKE(S_CLRAN3, 0);
    POKE(S_SETAN3, 0);
    POKE(S_CLRAN3, 0);
    POKE(S_SETAN3, 0);
    POKE(S_SET80VID, 0);
    POKE(S_CLRAN3, 0);
}

int main(void) {
    FILE *fp;
    uint8_t *hgr_buffer = ((uint8_t*)A_HGR_P1);

    // Enter DHGR mode
#if defined(DHGR_MODE)
    dhgr_mode();
#if defined(V7_MONO)
    v7_mono();
#endif
#else
    hgr_mode();
#endif

    // Load and show the splash screen
#if defined(DHGR_MODE)
    fp = fopen("SPLASH.DHR", "rb");
#else
    fp = fopen("SPLASH.HGR", "rb");
#endif
    if (!fp) return -1;

    fread(hgr_buffer, 1, HGR_PAGE_SIZE, fp);
#if defined(DHGR_MODE)
    // Move the 1st half of the picture to the aux ram, then copy over the rest
    main_to_aux(A_HGR_P1, A_HGR_P1 + (HGR_PAGE_SIZE-1), A_HGR_P1);
    fread(hgr_buffer, 1, HGR_PAGE_SIZE, fp);
#endif
    fclose(fp);

    // Load the EM driver
    if(em_load_driver("EM.DRV") != EM_ERR_OK) {
#if defined(DHGR_MODE)
        dhgr_mode_off();
#else
        hgr_mode_off();
#endif
        text_mode();
        printf("EM driver load failed!!!\n");
        sleep(3);
        return -1;
    }


    if(!load_resource_file()) {
#if defined(DHGR_MODE)
        dhgr_mode_off();
#else
        hgr_mode_off();
#endif
        text_mode();
        printf("Loading resources failed!!!\n");
        sleep(3);
        return -1;
    }


    // Reset the video mode
#if defined(DHGR_MODE)
    dhgr_mode_off();
#else
    hgr_mode_off();
#endif
    text_mode();

    // Load the next program!
    exec("GAME", NULL);

    return 0;
}
