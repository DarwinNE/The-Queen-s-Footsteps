; 
; Copy a screen to the map
;
; The z88 map consists of an area of 256 8x8 pixels graphics
;
; The HIRES0 character set contains the bitmaps that are displayed
; in the map area. When the map is opened (using window()) these
; are automatically setup, so we can just right directly to the 
; map area.
;
; The HIRES0 (at base_graphics) each byte represents the following
; position on screen.
;
; (x,y)
; (0,0) row 0
; ...
; (0,0) row 7
; (0,1) row 0
; ...
; (0,7) row 7

SECTION code_user

PUBLIC _z88_open_map
PUBLIC _z88_close_map
PUBLIC _z88_clear_map
PUBLIC _z88_copy_zx0_char_screen_to_map
EXTERN asm_dzx0_standard
EXTERN z88_map_segment
EXTERN z88_map_bank

INCLUDE "target/z88/def/map.def"
INCLUDE "target/z88/def/screen.def"


; Close the map - call after you've finished displaying
; void z88_close_map(void)
_z88_close_map:
    ld      a,'4'
    ld      bc,mp_del
    call_oz(os_map)
    ret

; Open the map - allows graphics to be shown
; int z88dk_open_map(int width) __z88dk_fastcall
_z88_open_map:
    ld      a,'4'       ; "Window" number
    ld      bc,mp_gra
    call_oz(os_map)
    ld      hl,-1
    ret     c           ;Failure
;Now get the address of the map
    ld      b,0
    ld      hl,0               ; dummy address
    ld      a,sc_hr0
    call_oz(os_sci)         ; get base address of map area (hires0)
    push    bc
    push    hl
    call_oz(os_sci)         ; (and re-write original address)
    pop     hl
    pop     bc
    ld      a,b
    ld      (z88_gfx_bank),a
    ld      a,h
    and     63                 ;mask to bank
    or      z88_map_segment            ;mask to segment map_seg
    ld      h,a
    ld      (z88_base_graphics),hl
    ld      hl,0            ;NULL=good
    ret
    

; Copy a zx0 compressed screen to the map - the screen is arranged optimally for
; the z88. In a character by character basis.
;
;
; void z88_copy_zx0_char_screen_to_map(void *data) __z88dk_fastcall
 
_z88_copy_zx0_char_screen_to_map:
    call    z88_swapgfx
    ld      de,(z88_base_graphics)
    call    asm_dzx0_standard
    ; Fall through
z88_swapgfx:
    push    hl
    ld      hl,z88_map_bank       ;$4Dx
    ld      e,(hl)
    ld      a,(z88_gfx_bank) 
    ld      (hl),a
    out     (z88_map_bank-$400),a
    ld      a,e
    ld      (z88_gfx_bank),a
    pop     hl
    ret

_z88_clear_map:
    call    z88_swapgfx
    ld      hl,(z88_base_graphics)
    ld      de,(z88_base_graphics)
    inc     de
    ld      bc,2047
    ld      (hl),0
    ldir
    jp      z88_swapgfx


SECTION bss_user

z88_gfx_bank:       defb    0
z88_base_graphics:  defw    0
