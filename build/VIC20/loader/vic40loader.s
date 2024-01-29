        PUTCH = $FFD2           ; Print the PETSCII char in A
        SETLFS = $FFBA          ; Set file parameters
        SETNAM = $FFBD          ; Set file name parameters
        LOAD = $FFD5            ; Load file
        CHKOUT = $FFC9          ; Set the default output device
        OPEN = $FFC0            ; Open a file
        CLRSCR = $E55F          ; Clear screen
        GETIN =  $FFE4          ; Get a key from the keyboard


; General-use addresses
        GRCHARS1 = $1C00    ; Address of user-defined characters.
        GRCHARS2 = $1100    ; Address of bitmap area shown during the loader
                            ; (and then used by the 40 column driver).

        VIC_DEFAULT=$EDE4   ; Table of the default values of VIC registers


; VIC-chip addresses
        VICSCRHO = $9000    ; Horizontal position of the screen
        VICSCRVE = $9001    ; Vertical position of the screen
        VICCOLNC = $9002    ; Screen width in columns and video memory addr.
        VICROWNC = $9003    ; Screen height, 8x8 or 8x16 chars, scan line addr.
        VICRAST  = $9004    ; Bits 8-1 of the current raster line
        VICCHGEN = $9005    ; Character gen. and video matrix addresses.
        GEN1     = $900A    ; First sound generator
        GEN2     = $900B    ; Second sound generator
        GEN3     = $900C    ; Third sound generator
        NOISE    = $900D    ; Noise sound generator
        VOLUME   = $900E    ; Volume and additional colour info
        VICCOLOR = $900F    ; Screen and border colours

        FREEAREA = $033C    ; Tiny little free memory area

        MEMSCR   = $1000    ; Start address of the screen memory (unexp. VIC)
        MEMCLR   = $9400    ; Start address of the colour memory (unexp. VIC)

loadHn = $17
loadHl = $19


.export _doload
.importzp ptr1

.segment "STARTUP"
.segment "LOWCODE"
.segment "LOADHI"
.segment "HIMEM"
.segment "INIT"
.segment "ONCE"
.segment "BSS"
.segment "FILLER"
; Reserve space that will be used for the graphic screens
.res    $1000, $EA
.segment "CODE"


_doload:    jsr CLRSCR
            lda #<CheckExp      ; Print the 32KB check message
            ldy #>CheckExp
            jsr PrintStr
            jsr checkexp        ; Check if the 32KB expansion is installed
            bcc @ok
            lda #<CheckErr
            ldy #>CheckErr
            jsr PrintStr
            lda #42             ; Set the screen and border colours
            sta VICCOLOR
@stop:      jmp @stop           ; Hang the computer here
@ok:
            lda #<CheckOK       ; Print (briefly) that everything is OK
            ldy #>CheckOK
            jsr PrintStr

            ldx 186             ; Get the last opened device
            bne @nozero         ; check if the device is zero
            ldx #8              ; Default device 8 if loader reads from FLASH
@nozero:    lda #2              ; File logic number
            ldy #255            ; Secondary address (command)
            jsr SETLFS

            lda #100            ; Disable RUN/STOP, RESTORE
            sta $328
            jsr Init
@askkey:                        ; Ask for a choice
            jsr _cgetc40ch
            cmp #'1'
            beq @load1
            cmp #'2'
            beq @load2
            cmp #'3'
            beq @load3
            jmp @askkey
@load1:
            lda #<(Hi1Name-@tocopy+FREEAREA)
            sta loadHn
            lda #>(Hi1Name-@tocopy+FREEAREA)
            sta loadHn+1
            lda #Hi1NameE-Hi1Name
            sta loadHl
            lda #PrgName1E-PrgName1   ; Filename length
            ldx #<PrgName1
            ldy #>PrgName1
            jmp @doload

@load2:     lda #<(Hi2Name-@tocopy+FREEAREA)
            sta loadHn
            lda #>(Hi2Name-@tocopy+FREEAREA)
            sta loadHn+1
            lda #Hi2NameE-Hi2Name
            sta loadHl
            lda #PrgName2E-PrgName2   ; Filename length
            ldx #<PrgName2
            ldy #>PrgName2
            jmp @doload

@load3:     lda #<(Hi3Name-@tocopy+FREEAREA)
            sta loadHn
            lda #>(Hi3Name-@tocopy+FREEAREA)
            sta loadHn+1
            lda #Hi3NameE-Hi3Name
            sta loadHl
            lda #PrgName3E-PrgName3   ; Filename length
            ldx #<PrgName3
            ldy #>PrgName3
            ;jmp @doload
@doload:
            jsr SETNAM
            ;lda #$C0            ; Put back the normal char gen address.
            ;sta VICCHGEN

            jsr LoadScr

            ldx #(_cgetc40ch-@tocopy+1)
@loop:      dex
            lda @tocopy,X
            sta FREEAREA,X
            cpx #0
            bne @loop
            jmp FREEAREA

@tocopy:                        ; This code is not executed here, but in the
            lda #0              ; version starting from FREEAREA.
            ldx #$FF
            ldy #$FF
            jsr LOAD
            bcs @error
            ldx 186             ; Get the last opened device
            bne @nozero1        ; check if the device is zero
            ldx #8              ; Default device to 8 if loader read from FLASH
@nozero1:   lda #2              ; File logic number
            ldy #255            ; Secondary address (command)
            jsr SETLFS
            lda loadHl          ; Load the high memory file
            ldx loadHn
            ldy loadHn+1
            jsr SETNAM
            lda #0
            ldx #$FF
            ldy #$FF
            jsr LOAD
            bcs @error
            jmp 8205            ; Launch the game!
            
@error:     pha
            ldx #$C0
            stx VICCHGEN
            ldx #$2e
            stx VICROWNC
            ldx #27
            stx VICCOLOR
            jsr CLRSCR
            lda #'e'
            jsr PUTCH
            lda #'r'
            jsr PUTCH
            lda #'r'
            jsr PUTCH
            lda #'o'
            jsr PUTCH
            lda #'r'
            jsr PUTCH
            lda #' '
            jsr PUTCH
            pla
            clc
            adc #48
            jsr PUTCH
            clc

@here:      bcc @here
Hi1Name:   .byte "himem1.bin"
Hi1NameE:
Hi2Name:   .byte "himem2.bin"
Hi2NameE:
Hi3Name:   .byte "himem3.bin"
Hi3NameE:

endArea:

; Get a keystroke and return it in the A register
_cgetc40ch:
@loop:
            jsr GETIN       ; Last instruction is a TXA, Z flag is up to date
            beq @loop
            rts

Init:       jsr CopyColours1
            jsr CopyScreen1
            jsr MovCh128_1
            lda #15         ; Set the screen and border colours
            sta VICCOLOR
            lda #$CF        ; Move the character generator address to $1C00
            sta VICCHGEN    ; while leaving ch. 128-255 to their original pos.
            lda #$F0        ; Turn off volume, set multicolour add. colour 14
            sta VOLUME
            rts

LoadScr:    jsr CopyColours2
            jsr CopyScreen2
            jsr MovCh128_2
            jsr _initGraphic
            rts

; Very simple check for the presence of a 32KB RAM expansion
; If the test pass, the carry is clear
; If the test fails, the carry is set
checkexp:
            ldx #$5A
            ldy #$A5
            stx $2010       ; Write in block 1
            sty $2011
            stx $4010       ; Write in block 2
            sty $4011
            stx $6010       ; Write in block 3
            sty $6011
            stx $A010       ; Write in block 5
            sty $A011

            ldx $2010       ; Check block 1
            ldy $2011
            cpx #$5A
            bne @fail
            cpy #$A5
            bne @fail
            ldx $4010       ; Check block 2
            ldy $4011
            cpx #$5A
            bne @fail
            cpy #$A5
            bne @fail
            ldx $6010       ; Check block 3
            ldy $6011
            cpx #$5A
            bne @fail
            cpy #$A5
            bne @fail
            ldx $A010       ; Check block 5
            ldy $A011
            cpx #$5A
            bne @fail
            cpy #$A5
            bne @fail
            clc
            rts
@fail:
            sec
            rts

; Print a string (null terminated) whose address is contained in A and
; Y

PrintStr:   sta ptr1
            sty ptr1+1
            ldy #0
@loop:      lda (ptr1),Y
            beq @exit
            jsr PUTCH
            iny
            jmp @loop
@exit:      rts

; Copy the graphic chars. Screen 1

MovCh128_1: ldx #255
@loop:      lda char_data1+0*$100,x
            sta GRCHARS1  +0*$100,x
            lda char_data1+1*$100,x
            sta GRCHARS1  +1*$100,x
            lda char_data1+2*$100,x
            sta GRCHARS1  +2*$100,x
            lda char_data1+3*$100,x
            sta GRCHARS1  +3*$100,x
            dex
            cpx #255
            bne @loop
            rts

CopyColours1:ldy #255
@CopyMem:   lda colour_data1,y
            sta MEMCLR,y
            lda colour_data1+256,y
            sta MEMCLR+256,y
            dey
            cpy #255
            bne @CopyMem

            rts

CopyScreen1: ldy #255
@CopyMem:   lda screen_data1,y
            sta MEMSCR,y
            lda screen_data1+256,y
            sta MEMSCR+256,y
            dey
            cpy #255
            bne @CopyMem
            rts

; Copy the graphic chars. Screen 2

; Init graphic mode
_initGraphic:
            ldy #$10
@On_02:
            clc
            lda VIC_DEFAULT,Y   ; Read default values from the KERNAL rom
            adc Offset,Y
            sta $9000,Y
            dey
            bpl @On_02
            rts

_normalText:
            ldy #$F
@On_02:
            lda VIC_DEFAULT,Y   ; Read default values from the KERNAL rom
            sta $9000,Y
            dey
            bpl @On_02
            jsr $e55f
            rts



; Example config:
; C:9000  0c 26 1E 2e  00 cd 57 ea  ff ff 00 00  00 00 00 08
;          |  |  | |   |   | |  |   |  |  |  |   |  |  |  +-> 0:2Bor 3RV 4-7BK
;          |  |  | |   |   | |  |   |  |  |  |   |  |  +-> 0:3 Vol 4-7 XCol
;          |  |  | |   |   | |  |   |  |  |  |   |  +-> Noise freq.
;          |  |  | |   |   | |  |   |  |  |  |   +-> Osc. 3 freq.
;          |  |  | |   |   | |  |   |  |  |  +-> Osc. 2 freq.
;          |  |  | |   |   | |  |   |  |  +-> Osc. 1 freq.
;          |  |  | |   |   | |  |   |  +-> Paddle Y
;          |  |  | |   |   | |  |   +-> Paddle X
;          |  |  | |   |   | |  +-> Light pen vertical position. 
;          |  |  | |   |   | +-> 0: 1, 1-7 Light pen horizontal.
;          |  |  | |   |   +-> 0-3 Char address, 4-7 Video address
;          |  |  | |   +-> Raster line (bits 8-1)
;          |  |  | +-> 0: 8/16 lines per char, 1-6 Number of cols, 7: Rast. b0
;          |  |  +-> 0-6: Number of columns 7: video address bit 9
;          |  +-> 0-7: Distance from origin to the first row
;          +-> 0-6: Distance from origin to the first column 7: interlace
;
; PAL system at startup:
; C:9000  0c 26 16 2e  00 c0 57 ea  ff ff 00 00  00 00 00 1b

N_COL=20                ; Number of columns (0-32)
N_ROW=12                ; Number of lines   (0-32)
ADDRESS_CHARGEN=$C      ; Address of character generator (see table)
ADDRESS_VIDEOMEM=$C     ; Address of character generator (see table)
CHAR16LINES=1           ; Use 8 bytes per character or 16 bytes per character

VOL=0                   ; Volume (0-15)
XCOL=9                  ; Auxiliary colour (0-15)
BACKGROUND=0            ; Background colour (0-15)
BORDER=7                ; Border colour (0-7)
REVERSE=1               ; Reverse background/foreground colours (0-1)

Offset:
    .byte 0, $00, 256+(N_COL-22), 256+((N_ROW)<<1+CHAR16LINES-$2E)
    .byte $00, (ADDRESS_VIDEOMEM<<4+ADDRESS_CHARGEN)-$c0
    .byte $00, $00, $00, $00, $00, $00, $00, $00, VOL+XCOL<<4
    .byte 256+(BACKGROUND<<4+REVERSE<<3+BORDER-27)

; Table of addresses for VIC memory addressing in register $05
; Value         VIC-chip                6502            NOTE
; -----------------------------------------------------------------------------
;   0 - $0      $0000 - 0000        $8000 - 32768   Normal Character ROM
;   1 - $1      $0400 - 1024        $8400 - 33792   Reverse Character ROM
;   2 - $2      $0800 - 2048        $8800 - 34816   Normal upper/lower ch. ROM
;   3 - $3      $0C00 - 3072        $8C00 - 35840   Reverse upper/lover ch. ROM
;   4 - $4      $1000 - 4096        $9000 - 36864   VIC/VIA chips (not usable)
;   5 - $5      $1400 - 5120        $9400 - 37888   Usually colour memory
;   6 - $6      $1800 - 6144        $9800 - 38912   Usually empty
;   7 - $7      $1C00 - 7168        $9C00 - 39936   Usually empty
;   8 - $8      $2000 - 8192        $0000 - 0       Page 0 (not usable)
;   9 - $9      $2400 - 9216        $0400 - 1024    Available with 3K expansion
;   10 - $A     $2800 - 10240       $0800 - 2048    Available with 3K expansion
;   11 - $B     $2C00 - 11264       $0C00 - 3072    Available with 3K expansion
;   12 - $C     $3000 - 12288       $1000 - 4096    Start of available RAM
;   13 - $D     $3400 - 13312       $1400 - 5120    Available
;   14 - $E     $3800 - 14336       $1800 - 6144    Available
;   15 - $F     $3C00 - 15360       $1C00 - 7168    Usually screen memory


OFS=0

MovCh128_2:   ldx #255
@loop:      lda char_data2+0*$100+OFS,x
            sta GRCHARS2  +0*$100,x
            lda char_data2+1*$100+OFS,x
            sta GRCHARS2  +1*$100,x
            lda char_data2+2*$100+OFS,x
            sta GRCHARS2  +2*$100,x
            lda char_data2+3*$100+OFS,x
            sta GRCHARS2  +3*$100,x
            lda char_data2+4*$100+OFS,x
            sta GRCHARS2  +4*$100,x
            lda char_data2+5*$100+OFS,x
            sta GRCHARS2  +5*$100,x
            lda char_data2+6*$100+OFS,x
            sta GRCHARS2  +6*$100,x
            lda char_data2+7*$100+OFS,x
            sta GRCHARS2  +7*$100,x
            lda char_data2+8*$100+OFS,x
            sta GRCHARS2  +8*$100,x
            lda char_data2+9*$100+OFS,x
            sta GRCHARS2  +9*$100,x
            lda char_data2+10*$100+OFS,x
            sta GRCHARS2  +10*$100,x
            lda char_data2+11*$100+OFS,x
            sta GRCHARS2  +11*$100,x
            lda char_data2+12*$100+OFS,x
            sta GRCHARS2  +12*$100,x
            lda char_data2+13*$100+OFS,x
            sta GRCHARS2  +13*$100,x
            lda char_data2+14*$100+OFS,x
            sta GRCHARS2  +14*$100,x
            lda char_data2+15*$100+OFS,x
            sta GRCHARS2  +15*$100,x
            lda char_data2+16*$100+OFS,x
            sta GRCHARS2  +16*$100,x
            dex
            cpx #255
            bne @loop
            rts

CopyColours2:ldy #255
@CopyMem:   lda colour_data2,y
            sta MEMCLR,y
            lda colour_data2+256,y
            sta MEMCLR+256,y
            dey
            cpy #255
            bne @CopyMem

            rts

CopyScreen2: ldy #255
@CopyMem:   lda screen_data2,y
            sta MEMSCR,y
            ;lda screen_data2+256,y
            ;sta MEMSCR+256,y
            dey
            cpy #255
            bne @CopyMem
            rts


LoadErr:    .byte 31
            .asciiz "load error"
Loading:    .byte 159
            .asciiz "loading... please wait"
CheckExp:   .byte 144   ; Code for the black cursor
            .asciiz "check 32kb exp.: "
CheckOK:    .asciiz "ok"
CheckErr:   .byte 5
            .asciiz "fail!install 32kb exp."

PrgName1:   .byte "queens-vic1"
PrgName1E:
PrgName2:   .byte "queens-vic2"
PrgName2E:
PrgName3:   .byte "queens-vic3"
PrgName3E:

;settings
;background-colour=0
;border-colour=7
;aux-colour=15
;char-height=8
;row-count=23
;col-count=22

char_data1:
.byte  $FE,$81,$67,$E7,$E7,$E7,$F7,$FB
.byte  $C3,$BF,$7F,$07,$7F,$7F,$7F,$FF
.byte  $FF,$FF,$87,$7B,$7B,$7B,$87,$FF
.byte  $FF,$FF,$83,$7B,$7B,$7B,$07,$7F
.byte  $00,$00,$78,$80,$78,$04,$F8,$00
.byte  $00,$00,$78,$84,$F8,$82,$7C,$00
.byte  $00,$18,$18,$18,$18,$18,$08,$04
.byte  $00,$00,$7C,$90,$10,$10,$10,$08
.byte  $00,$00,$7C,$84,$84,$84,$F8,$80
.byte  $00,$00,$78,$84,$84,$84,$88,$86
.byte  $FF,$FF,$87,$7F,$87,$FB,$07,$FF
.byte  $FF,$FF,$87,$7B,$07,$7D,$83,$FF
.byte  $BF,$DF,$C3,$DD,$DD,$DD,$DD,$FB
.byte  $FF,$FF,$83,$6F,$EF,$EF,$EF,$F7
.byte  $00,$00,$78,$84,$84,$84,$7E,$00
.byte  $FF,$FF,$C3,$BD,$BD,$BD,$BD,$FE
.byte  $87,$7B,$7D,$7D,$7D,$79,$81,$FE
.byte  $00,$00,$78,$80,$80,$80,$78,$00
.byte  $FF,$FF,$7D,$7B,$7B,$7B,$87,$FF
.byte  $EF,$EF,$DF,$BF,$FF,$FF,$FF,$FF
.byte  $00,$00,$03,$FF,$FF,$FF,$FF,$FC
.byte  $00,$00,$00,$00,$01,$02,$02,$01
.byte  $7F,$C0,$9F,$BF,$30,$60,$60,$60
.byte  $73,$71,$61,$60,$2E,$A9,$AC,$AB
.byte  $B0,$90,$98,$89,$60,$20,$10,$0D
.byte  $05,$05,$04,$02,$02,$02,$02,$02
.byte  $0E,$71,$82,$82,$1C,$E0,$00,$00
.byte  $01,$02,$02,$02,$02,$02,$01,$00
.byte  $01,$01,$01,$01,$01,$01,$01,$01
.byte  $AB,$57,$2B,$57,$AB,$57,$2B,$57
.byte  $01,$01,$01,$01,$01,$00,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $6F,$BF,$6F,$BF,$6F,$BF,$6F,$BF
.byte  $00,$00,$3F,$40,$C0,$1F,$20,$A0
.byte  $BF,$3F,$00,$00,$7F,$7F,$00,$00
.byte  $FF,$FF,$FF,$00,$6E,$BB,$6F,$BF
.byte  $00,$00,$18,$28,$08,$08,$1C,$00
.byte  $6F,$BF,$6F,$3F,$6F,$3F,$6F,$3F
.byte  $3F,$9F,$4F,$4F,$4F,$27,$63,$80
.byte  $30,$7F,$7F,$7F,$3F,$3F,$1F,$41
.byte  $28,$58,$2F,$5B,$2F,$5B,$2F,$5B
.byte  $6F,$1B,$2F,$1B,$2F,$1B,$2F,$1B
.byte  $2F,$5B,$2F,$5B,$2F,$8B,$8F,$E1
.byte  $10,$10,$0F,$00,$00,$00,$00,$00
.byte  $FC,$FC,$FC,$F0,$C0,$00,$00,$00
.byte  $00,$08,$14,$04,$08,$10,$1C,$00
.byte  $00,$08,$14,$04,$08,$04,$18,$00
.byte  $00,$00,$FC,$02,$01,$88,$80,$E0
.byte  $E0,$88,$0C,$0F,$FF,$FF,$00,$00
.byte  $FF,$FF,$FF,$7F,$00,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$08,$10,$20,$28,$3C,$08,$00
.byte  $00,$00,$08,$08,$3E,$08,$08,$00
.byte  $3F,$00,$00,$FF,$FF,$FF,$FF,$FF
.byte  $00,$00,$E0,$FF,$FF,$FF,$FF,$FF
.byte  $3C,$40,$40,$3C,$02,$02,$3C,$00
.byte  $00,$FF,$00,$00,$00,$00,$00,$00
.byte  $7F,$7F,$00,$FF,$00,$00,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$00,$00,$00,$E0,$10,$50,$50
.byte  $5F,$4F,$C0,$C0,$FC,$FF,$00,$00
.byte  $FF,$FF,$FF,$00,$10,$AA,$D4,$AA
.byte  $D5,$EA,$D4,$EA,$D5,$EA,$D4,$EA
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $F8,$00,$00,$FF,$FF,$FF,$FE,$F8
.byte  $05,$02,$D5,$EA,$D5,$EA,$D5,$EA
.byte  $D5,$EA,$D5,$EA,$D5,$EA,$D5,$EA
.byte  $D5,$EA,$D5,$EA,$D5,$EA,$D5,$EA
.byte  $D4,$EA,$01,$FE,$00,$00,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$00,$00,$00,$00,$01,$02,$02
.byte  $02,$04,$85,$7D,$01,$E3,$03,$03
.byte  $F7,$F7,$F7,$07,$07,$0F,$0F,$0F
.byte  $0F,$0F,$0F,$0F,$1E,$1E,$1C,$18
.byte  $18,$18,$38,$3F,$3F,$3F,$1F,$9F
.byte  $1F,$1F,$1F,$1F,$1F,$1F,$1F,$0F
.byte  $0F,$0F,$CF,$CF,$CF,$8F,$07,$87
.byte  $07,$87,$47,$87,$07,$83,$43,$81
.byte  $01,$80,$40,$80,$01,$81,$41,$81
.byte  $03,$82,$42,$84,$04,$88,$48,$10
.byte  $20,$40,$80,$00,$00,$00,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $0F,$18,$60,$8F,$8F,$1F,$7F,$7F
.byte  $7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $55,$55,$55,$55,$4F,$2A,$2A,$2A
.byte  $AA,$AA,$2A,$2A,$40,$57,$55,$55
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FE,$FE,$FE,$FC,$FD,$FE
.byte  $F1,$E2,$04,$18,$E0,$00,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$00,$80,$40,$40,$20,$A0,$A0
.byte  $A0,$90,$D0,$D0,$D0,$E8,$E8,$E8
.byte  $E8,$E8,$F4,$F4,$F4,$F4,$F4,$F4
.byte  $54,$54,$54,$57,$FF,$FF,$FF,$BF
.byte  $EF,$AF,$AB,$2F,$FF,$FC,$50,$50
.byte  $E2,$E4,$E4,$E4,$E4,$E8,$C8,$C8
.byte  $C8,$D0,$90,$90,$A0,$20,$20,$20
.byte  $40,$40,$40,$80,$80,$80,$00,$00
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $00,$01,$00,$01,$00,$01,$00,$01
.byte  $00,$00,$02,$00,$02,$00,$04,$00
.byte  $04,$04,$00,$04,$04,$00,$08,$00
.byte  $00,$08,$00,$00,$08,$00,$00,$08
.byte  $00,$04,$04,$00,$00,$02,$00,$02
.byte  $00,$02,$00,$02,$00,$02,$00,$02
.byte  $00,$02,$00,$02,$00,$02,$00,$02
.byte  $00,$02,$00,$02,$00,$02,$00,$02
.byte  $00,$04,$00,$08,$10,$00,$20,$20
.byte  $00,$00,$40,$00,$40,$00,$40,$00
.byte  $E3,$DD,$B5,$A9,$B3,$DF,$E1,$FF
; .byte  $E7,$DB,$BD,$81,$BD,$BD,$BD,$FF
; .byte  $83,$DD,$DD,$C3,$DD,$DD,$83,$FF
; .byte  $E3,$DD,$BF,$BF,$BF,$DD,$E3,$FF
; .byte  $87,$DB,$DD,$DD,$DD,$DB,$87,$FF
; .byte  $81,$BF,$BF,$87,$BF,$BF,$81,$FF
; .byte  $81,$BF,$BF,$87,$BF,$BF,$BF,$FF
; .byte  $E3,$DD,$BF,$B1,$BD,$DD,$E3,$FF
; .byte  $BD,$BD,$BD,$81,$BD,$BD,$BD,$FF
; .byte  $E3,$F7,$F7,$F7,$F7,$F7,$E3,$FF
; .byte  $F1,$FB,$FB,$FB,$FB,$BB,$C7,$FF
; .byte  $BD,$BB,$B7,$8F,$B7,$BB,$BD,$FF
; .byte  $BF,$BF,$BF,$BF,$BF,$BF,$81,$FF
; .byte  $BD,$99,$A5,$A5,$BD,$BD,$BD,$FF
; .byte  $BD,$9D,$AD,$B5,$B9,$BD,$BD,$FF
; .byte  $E7,$DB,$BD,$BD,$BD,$DB,$E7,$FF
; .byte  $83,$BD,$BD,$83,$BF,$BF,$BF,$FF
; .byte  $E7,$DB,$BD,$BD,$B5,$DB,$E5,$FF
; .byte  $83,$BD,$BD,$83,$B7,$BB,$BD,$FF
; .byte  $C3,$BD,$BF,$C3,$FD,$BD,$C3,$FF
; .byte  $C1,$F7,$F7,$F7,$F7,$F7,$F7,$FF
; .byte  $BD,$BD,$BD,$BD,$BD,$BD,$C3,$FF
; .byte  $BD,$BD,$BD,$DB,$DB,$E7,$E7,$FF
; .byte  $BD,$BD,$BD,$A5,$A5,$99,$BD,$FF
; .byte  $BD,$BD,$DB,$E7,$DB,$BD,$BD,$FF
; .byte  $DD,$DD,$DD,$E3,$F7,$F7,$F7,$FF
; .byte  $81,$FD,$FB,$E7,$DF,$BF,$81,$FF
; .byte  $C3,$DF,$DF,$DF,$DF,$DF,$C3,$FF
; .byte  $F3,$EF,$EF,$C3,$EF,$8F,$91,$FF
; .byte  $C3,$FB,$FB,$FB,$FB,$FB,$C3,$FF
; .byte  $FF,$F7,$E3,$D5,$F7,$F7,$F7,$F7
; .byte  $FF,$FF,$EF,$DF,$80,$DF,$EF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byte  $F7,$F7,$F7,$F7,$FF,$FF,$F7,$FF
; .byte  $DB,$DB,$DB,$FF,$FF,$FF,$FF,$FF
; .byte  $DB,$DB,$81,$DB,$81,$DB,$DB,$FF
; .byte  $F7,$E1,$D7,$E3,$F5,$C3,$F7,$FF
; .byte  $FF,$9D,$9B,$F7,$EF,$D9,$B9,$FF
; .byte  $CF,$B7,$B7,$CF,$B5,$BB,$C5,$FF
; .byte  $FB,$F7,$EF,$FF,$FF,$FF,$FF,$FF
; .byte  $FB,$F7,$EF,$EF,$EF,$F7,$FB,$FF
; .byte  $DF,$EF,$F7,$F7,$F7,$EF,$DF,$FF
; .byte  $F7,$D5,$E3,$C1,$E3,$D5,$F7,$FF
; .byte  $FF,$F7,$F7,$C1,$F7,$F7,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$F7,$F7,$EF
; .byte  $FF,$FF,$FF,$81,$FF,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$E7,$E7,$FF
; .byte  $FF,$FD,$FB,$F7,$EF,$DF,$BF,$FF
; .byte  $C3,$BD,$B9,$A5,$9D,$BD,$C3,$FF
; .byte  $F7,$E7,$D7,$F7,$F7,$F7,$C1,$FF
; .byte  $C3,$BD,$FD,$F3,$CF,$BF,$81,$FF
; .byte  $C3,$BD,$FD,$E3,$FD,$BD,$C3,$FF
; .byte  $FB,$F3,$EB,$DB,$81,$FB,$FB,$FF
; .byte  $81,$BF,$87,$FB,$FD,$BB,$C7,$FF
; .byte  $E3,$DF,$BF,$83,$BD,$BD,$C3,$FF
; .byte  $81,$BD,$FB,$F7,$EF,$EF,$EF,$FF
; .byte  $C3,$BD,$BD,$C3,$BD,$BD,$C3,$FF
; .byte  $C3,$BD,$BD,$C1,$FD,$FB,$C7,$FF
; .byte  $FF,$FF,$F7,$FF,$FF,$F7,$FF,$FF
; .byte  $FF,$FF,$F7,$FF,$FF,$F7,$F7,$EF
; .byte  $F1,$E7,$CF,$9F,$CF,$E7,$F1,$FF
; .byte  $FF,$FF,$81,$FF,$81,$FF,$FF,$FF
; .byte  $8F,$E7,$F3,$F9,$F3,$E7,$8F,$FF
; .byte  $C3,$BD,$FD,$F3,$EF,$FF,$EF,$FF
; .byte  $FF,$FF,$FF,$FF,$00,$FF,$FF,$FF
; .byte  $F7,$E3,$C1,$80,$80,$E3,$C1,$FF
; .byte  $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
; .byte  $FF,$FF,$FF,$00,$FF,$FF,$FF,$FF
; .byte  $FF,$FF,$00,$FF,$FF,$FF,$FF,$FF
; .byte  $FF,$00,$FF,$FF,$FF,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$00,$FF,$FF
; .byte  $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
; .byte  $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
; .byte  $FF,$FF,$FF,$FF,$1F,$EF,$F7,$F7
; .byte  $F7,$F7,$F7,$FB,$FC,$FF,$FF,$FF
; .byte  $F7,$F7,$F7,$EF,$1F,$FF,$FF,$FF
; .byte  $7F,$7F,$7F,$7F,$7F,$7F,$7F,$00
; .byte  $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE
; .byte  $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
; .byte  $00,$7F,$7F,$7F,$7F,$7F,$7F,$7F
; .byte  $00,$FE,$FE,$FE,$FE,$FE,$FE,$FE
; .byte  $FF,$C3,$81,$81,$81,$81,$C3,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$FF,$00,$FF
; .byte  $C9,$80,$80,$80,$C1,$E3,$F7,$FF
; .byte  $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
; .byte  $FF,$FF,$FF,$FF,$FC,$FB,$F7,$F7
; .byte  $7E,$BD,$DB,$E7,$E7,$DB,$BD,$7E
; .byte  $FF,$C3,$BD,$BD,$BD,$BD,$C3,$FF
; .byte  $F7,$E3,$D5,$88,$D5,$F7,$F7,$FF
; .byte  $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
; .byte  $F7,$E3,$C1,$80,$C1,$E3,$F7,$FF
; .byte  $F7,$F7,$F7,$F7,$00,$F7,$F7,$F7
; .byte  $5F,$AF,$5F,$AF,$5F,$AF,$5F,$AF
; .byte  $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
; .byte  $FF,$FF,$FE,$C1,$AB,$EB,$EB,$FF
; .byte  $00,$80,$C0,$E0,$F0,$F8,$FC,$FE
; .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byte  $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
; .byte  $FF,$FF,$FF,$FF,$00,$00,$00,$00
; .byte  $00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
; .byte  $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
; .byte  $55,$AA,$55,$AA,$55,$AA,$55,$AA
; .byte  $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
; .byte  $FF,$FF,$FF,$FF,$55,$AA,$55,$AA
; .byte  $00,$01,$03,$07,$0F,$1F,$3F,$7F
; .byte  $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
; .byte  $F7,$F7,$F7,$F7,$F0,$F7,$F7,$F7
; .byte  $FF,$FF,$FF,$FF,$F0,$F0,$F0,$F0
; .byte  $F7,$F7,$F7,$F7,$F0,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$07,$F7,$F7,$F7
; .byte  $FF,$FF,$FF,$FF,$FF,$FF,$00,$00
; .byte  $FF,$FF,$FF,$FF,$F0,$F7,$F7,$F7
; .byte  $F7,$F7,$F7,$F7,$00,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$00,$F7,$F7,$F7
; .byte  $F7,$F7,$F7,$F7,$07,$F7,$F7,$F7
; .byte  $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
; .byte  $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
; .byte  $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
; .byte  $00,$00,$FF,$FF,$FF,$FF,$FF,$FF
; .byte  $00,$00,$00,$FF,$FF,$FF,$FF,$FF
; .byte  $FF,$FF,$FF,$FF,$FF,$00,$00,$00
; .byte  $FE,$FE,$FE,$FE,$FE,$FE,$FE,$00
; .byte  $FF,$FF,$FF,$FF,$0F,$0F,$0F,$0F
; .byte  $F0,$F0,$F0,$F0,$FF,$FF,$FF,$FF
; .byte  $F7,$F7,$F7,$F7,$07,$FF,$FF,$FF
; .byte  $0F,$0F,$0F,$0F,$FF,$FF,$FF,$FF
; .byte  $0F,$0F,$0F,$0F,$F0,$F0,$F0,$F0


screen_data1:

.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $1D,$34,$34,$34,$34,$34,$34,$34
.byte  $34,$34,$42,$20,$20,$15,$23,$31
.byte  $3F,$4D,$5B,$69,$20,$20,$1D,$34
.byte  $34,$34,$00,$0C,$0B,$34,$34,$34
.byte  $42,$20,$20,$16,$24,$32,$40,$4E
.byte  $5C,$6A,$20,$20,$1D,$34,$34,$34
.byte  $34,$34,$34,$34,$34,$34,$42,$20
.byte  $20,$17,$25,$33,$41,$4F,$5D,$6B
.byte  $20,$20,$1D,$34,$10,$12,$0B,$0B
.byte  $0F,$13,$0A,$34,$42,$20,$20,$18
.byte  $22,$34,$42,$50,$5E,$6C,$14,$20
.byte  $1D,$34,$34,$34,$34,$34,$34,$34
.byte  $34,$34,$42,$20,$20,$19,$27,$34
.byte  $42,$51,$5F,$6D,$2E,$20,$1D,$01
.byte  $02,$02,$0D,$0A,$0D,$0B,$03,$0A
.byte  $42,$20,$20,$1A,$28,$34,$42,$52
.byte  $60,$6E,$20,$20,$1D,$34,$34,$34
.byte  $34,$34,$34,$34,$34,$34,$42,$20
.byte  $20,$1B,$29,$37,$45,$53,$61,$6F
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$1C
.byte  $2A,$38,$46,$54,$62,$70,$20,$20
.byte  $20,$20,$20,$39,$05,$06,$05,$11
.byte  $07,$20,$20,$20,$20,$1C,$2B,$34
.byte  $47,$55,$63,$20,$20,$20,$20,$20
.byte  $20,$3A,$3A,$3A,$3A,$3A,$3A,$20
.byte  $20,$20,$20,$1E,$2C,$34,$48,$56
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$2D,$3B,$49,$57,$20,$20
.byte  $20,$20,$B1,$20,$08,$0E,$09,$07
.byte  $20,$26,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$B2,$20
.byte  $08,$0E,$09,$07,$20,$2F,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$B3,$20,$08,$0E,$09,$07
.byte  $04,$20,$30,$36,$35,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$84,$81,$96,$89,$84,$85
.byte  $20,$82,$95,$83,$83,$89,$20,$20
.byte  $B2,$B0,$B2,$B0,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20,$20,$20,$20,$20,$20,$20
.byte  $20,$20

colour_data1:

.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$0A,$0A,$0A,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$0A,$0A,$0A,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$01,$01,$01,$01,$01,$01
.byte  $07,$01,$01,$01,$01,$01,$07,$07
.byte  $01,$01,$01,$01,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$07
.byte  $07,$07



char_data2:
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
.byte  $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FE
.byte  $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$33,$55,$53,$55,$33
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FE,$FF,$FD,$FD
.byte  $F9,$FB,$FB,$FB,$FB,$FB,$F7,$F7,$F7,$F7,$F7,$EF,$EF,$EF,$EE,$CE
.byte  $DE,$DE,$DE,$DE,$DE,$9E,$BE,$BC,$BC,$BC,$BC,$BC,$B8,$78,$79,$79
.byte  $52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52,$52
.byte  $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$52,$52
.byte  $52,$52,$52,$52,$52,$52,$52,$12,$12,$12,$12,$12,$14,$14,$14,$14
.byte  $BC,$BC,$BC,$BC,$BC,$9C,$DC,$DC,$DE,$DE,$DE,$CE,$EE,$EF,$EF,$EF
.byte  $E7,$F7,$F7,$F7,$F3,$FB,$FB,$FB,$F9,$F9,$FD,$FD,$FC,$FC,$FE,$FE
.byte  $FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$BB,$55,$D5,$B5,$1B
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FE,$FE,$FE,$FD,$FD,$FF,$FB,$F3,$F7,$F7,$EF,$EF
.byte  $45,$45,$45,$45,$15,$15,$14,$14,$14,$14,$56,$52,$52,$52,$52,$52
.byte  $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
.byte  $3F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$7F,$7F,$7F,$7F,$7F,$3F,$3F,$3F,$3F,$3F,$1F,$1F
.byte  $2A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$52,$52,$52,$52,$52
.byte  $71,$78,$78,$78,$38,$3C,$9C,$9E,$DE,$CE,$CE,$EF,$E7,$E7,$F7,$F3
.byte  $FB,$F9,$F9,$FC,$FC,$FE,$FE,$FF,$FF,$FE,$FF,$B7,$2B,$B3,$BB,$17
.byte  $FF,$FF,$FF,$FF,$FE,$FC,$FD,$F9,$FB,$F7,$F7,$EF,$EF,$DF,$DF,$BF
.byte  $15,$15,$14,$54,$54,$54,$54,$54,$52,$52,$52,$4A,$4A,$4A,$4A,$2A
.byte  $9F,$1F,$3F,$3F,$3F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$CF,$8B,$3B,$3B,$BB,$BB,$BB,$BA,$B8
.byte  $B9,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$F3,$E1,$DD,$DE,$BE,$BE,$BE,$3E,$3E,$3E,$3E
.byte  $9E,$9C,$CC,$C4,$F1,$F0,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FC,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FC,$FC,$FC,$FD,$FD,$FD,$FD
.byte  $A8,$A8,$A8,$AA,$AA,$AA,$AA,$2A,$2A,$2A,$2A,$2A,$2A,$4A,$4A,$4A
.byte  $4A,$52,$52,$52,$52,$16,$14,$14,$14,$05,$45,$45,$45,$45,$51,$51
.byte  $DF,$BF,$BF,$7F,$FE,$FC,$FC,$F9,$F1,$F1,$E1,$E1,$C1,$C1,$81,$91
.byte  $11,$09,$19,$19,$19,$19,$11,$11,$12,$16,$14,$05,$91,$84,$81,$84
.byte  $E0,$E0,$F8,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$D8,$DB,$DB,$DB,$DB,$DB,$9B,$18,$59
.byte  $DB,$DB,$DB,$DB,$DB,$DB,$DB,$D8,$D8,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$DD,$DD,$DC,$DE,$DE,$DE,$DE,$DF,$DF,$DF,$DF
.byte  $CF,$EF,$EF,$E6,$E4,$F0,$F9,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$1E,$FE,$FD,$FD,$FB,$FB,$FB,$FB,$FB,$7B,$3B,$FB,$FB,$FB,$FB
.byte  $F8,$FC,$FC,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$7F,$7F,$3F,$1F,$0F,$87,$87,$C3
.byte  $48,$01,$25,$04,$09,$0A,$49,$0A,$02,$42,$41,$50,$51,$40,$09,$08
.byte  $0A,$2A,$2A,$2A,$6A,$0A,$0A,$00,$41,$50,$15,$00,$81,$54,$01,$40
.byte  $41,$01,$0F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$E1,$EF,$EF,$EF,$EF,$EF,$E3,$67,$6F,$6F,$6F
.byte  $6F,$6F,$6F,$6F,$EF,$E3,$E1,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FE,$7C,$7D,$BB,$BB,$BB,$DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB,$BB
.byte  $38,$38,$7C,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $24,$13,$C8,$27,$10,$0C,$83,$60,$10,$8C,$63,$18,$06,$C1,$30,$08
.byte  $00,$A0,$A8,$AA,$A8,$A1,$80,$04,$10,$41,$04,$11,$40,$04,$10,$41
.byte  $46,$82,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8,$A8,$A8
.byte  $A8,$A8,$A3,$A3,$A3,$A3,$A3,$8F,$8F,$8F,$8F,$8F,$8F,$3F,$3F,$3F
.byte  $3F,$3F,$33,$30,$30,$3F,$8C,$83,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
.byte  $A0,$A3,$A3,$A0,$A8,$AA,$A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
.byte  $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$C3,$DF,$DF,$DF,$DF,$DF,$C7,$CF,$DF,$DF,$DF
.byte  $DF,$DF,$DF,$DF,$DF,$C7,$C3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$F8,$70,$63,$63,$AB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$3B
.byte  $3B,$3B,$7B,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $15,$14,$11,$54,$01,$04,$51,$44,$10,$05,$12,$61,$94,$40,$10,$10
.byte  $40,$10,$40,$03,$53,$13,$43,$0F,$4F,$0F,$4F,$3F,$3F,$3F,$3C,$30
.byte  $30,$00,$07,$0F,$1F,$3F,$3F,$3F,$3C,$3C,$3C,$3C,$3C,$FC,$FC,$FC
.byte  $FC,$F0,$F3,$F0,$C0,$F0,$FC,$FC,$FC,$FC,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$3F,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$3F,$8F,$0B,$8F,$BF,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$BF,$80,$A2,$AA,$AA,$AA
.byte  $FF,$FF,$FF,$FC,$FE,$7A,$7A,$7B,$7B,$3B,$3B,$1B,$4B,$63,$73,$73
.byte  $7B,$7B,$7B,$7B,$7B,$7B,$7B,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$F7,$EB,$EF,$CF,$CF,$CF,$EF,$E7,$F7,$F3,$FB,$39,$39,$39,$39
.byte  $03,$83,$C7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $51,$40,$44,$11,$44,$51,$04,$53,$03,$43,$0F,$0F,$0F,$3F,$3F,$3F
.byte  $7F,$00,$8A,$A0,$EA,$CA,$F2,$FC,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$3F
.byte  $3F,$0F,$0F,$C7,$C3,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$CF,$0F,$8F,$0F,$3F,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$C2,$0A,$AA,$AA,$AA,$AA
.byte  $FF,$FF,$FF,$FF,$FF,$DF,$8F,$AF,$BF,$BF,$9F,$CF,$CF,$E7,$E7,$F7
.byte  $37,$37,$37,$27,$07,$8F,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$C7,$87,$9F,$5F,$5F,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
.byte  $DF,$DF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC
.byte  $32,$47,$9E,$31,$6F,$58,$DF,$33,$0E,$1C,$BB,$B7,$83,$8E,$9E,$90
.byte  $01,$00,$A8,$A8,$28,$AA,$AA,$82,$28,$2A,$C8,$C2,$CA,$C2,$C0,$C0
.byte  $C0,$C0,$C1,$C1,$E0,$E0,$E1,$F1,$F0,$F8,$F8,$F8,$FC,$FC,$FE,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$03,$A8,$A8,$A8,$A8,$A8,$AA,$AA
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$0E,$7E,$7E,$7E,$7E,$7E,$7E,$1E,$3E,$7E,$7E,$7E,$7E,$7E,$7E
.byte  $7E,$1E,$0E,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $AA,$AA,$AA,$AA,$AA,$AA,$A8,$A8,$A8,$A1,$A3,$8D,$8B,$8D,$37,$1D
.byte  $2A,$2A,$2A,$4A,$4A,$4A,$42,$12,$52,$04,$50,$44,$10,$44,$55,$11
.byte  $44,$51,$05,$10,$85,$A0,$A9,$A8,$A8,$82,$2A,$A0,$8A,$A8,$00,$00
.byte  $40,$04,$54,$10,$52,$40,$20,$AA,$AA,$A8,$0A,$5A,$10,$15,$15,$00
.byte  $00,$81,$85,$C0,$E0,$F0,$F8,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F
.byte  $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$BF,$8F,$8F,$8F,$8F,$8F,$A3,$A3
.byte  $F0,$F8,$FC,$FC,$FC,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$3F,$DF,$DF,$CE,$EE,$EE,$EF,$EF,$EF,$DF,$DF,$39,$39,$F9,$F8
.byte  $F8,$FC,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FC,$FC,$F8,$F8,$F8
.byte  $A3,$A1,$A3,$8D,$87,$1D,$77,$DD,$77,$DD,$77,$DD,$77,$DD,$77,$DD
.byte  $15,$54,$11,$85,$84,$81,$85,$A0,$A1,$A0,$A1,$A8,$28,$2A,$2A,$2A
.byte  $2A,$0A,$0A,$0A,$4A,$02,$12,$02,$44,$10,$01,$44,$10,$41,$04,$10
.byte  $04,$00,$00,$A0,$A8,$8A,$00,$AA,$A0,$84,$84,$84,$90,$13,$4F,$0F
.byte  $0F,$CF,$CF,$FF,$3F,$3F,$CF,$C3,$C3,$C3,$CF,$3F,$3C,$3C,$FC,$FC
.byte  $F0,$F3,$FF,$FF,$FF,$FF,$FC,$3C,$3C,$3C,$C3,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FE,$FC,$FC,$FB,$F8,$FC,$FC,$FE,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$3F,$3F,$3F,$3F,$8F,$8F,$8F,$A3,$A3,$A3
.byte  $FC,$BC,$5E,$7E,$7E,$7F,$7F,$3F,$3F,$9F,$DE,$CE,$CE,$CE,$CE,$1F
.byte  $23,$21,$23,$A1,$87,$8D,$87,$0D,$37,$1D,$77,$DD,$74,$DC,$74,$DC
.byte  $72,$D2,$72,$D2,$72,$CA,$4A,$CA,$4A,$28,$22,$22,$22,$2A,$28,$22
.byte  $F3,$CD,$99,$32,$66,$CC,$DD,$99,$3A,$64,$6D,$ED,$4B,$12,$76,$6C
.byte  $04,$01,$A5,$21,$88,$88,$8A,$2A,$2A,$2A,$28,$28,$28,$08,$40,$40
.byte  $40,$58,$50,$24,$24,$16,$06,$06,$02,$02,$06,$C2,$F2,$F2,$FC,$CF
.byte  $CC,$CC,$CC,$CC,$CC,$CC,$CC,$3C,$3C,$3C,$30,$F0,$F0,$F0,$F0,$F0
.byte  $CD,$CD,$3D,$3D,$3C,$EC,$FC,$FC,$FC,$FC,$FC,$F8,$F0,$F0,$E2,$E1
.byte  $C0,$D2,$D0,$91,$81,$0D,$ED,$2D,$2E,$6E,$2E,$2E,$26,$06,$00,$90
.byte  $A0,$C2,$EF,$FF,$FF,$FF,$F0,$F8,$FC,$FE,$FE,$FC,$FC,$B3,$2B,$CF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$F2,$F2,$F2,$F2,$F2,$F2
.byte  $F2,$F2,$F2,$F2,$32,$32,$32,$32,$32,$F2,$F2,$F2,$F2,$F2,$32,$02
.byte  $CA,$4A,$CA,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$28,$28,$AA,$A8,$A8,$A8
.byte  $FC,$FD,$FD,$FD,$F9,$FB,$FB,$FB,$FB,$FB,$F3,$F3,$F7,$F7,$F7,$EF
.byte  $40,$11,$49,$48,$08,$48,$08,$2A,$2A,$22,$28,$22,$0A,$22,$2A,$08
.byte  $76,$77,$77,$7E,$7F,$76,$76,$36,$76,$8E,$0E,$28,$00,$00,$80,$E0
.byte  $80,$A0,$A2,$AA,$AA,$AA,$28,$28,$28,$28,$21,$25,$00,$40,$54,$00
.byte  $15,$15,$55,$51,$49,$69,$69,$69,$69,$68,$69,$49,$51,$15,$15,$54
.byte  $40,$01,$14,$52,$12,$12,$12,$10,$07,$05,$C0,$C0,$00,$71,$75,$3C
.byte  $3C,$BE,$FE,$DE,$DE,$DE,$CE,$CE,$CC,$CC,$8C,$0C,$4C,$4C,$08,$48
.byte  $32,$32,$32,$32,$32,$32,$32,$F2,$F2,$F2,$E2,$CA,$CA,$CA,$CA,$CA
.byte  $CA,$CA,$CA,$CA,$CA,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
.byte  $3D,$BD,$F9,$FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB,$F7,$F7,$F7,$F7
.byte  $F7,$F7,$E7,$E7,$6F,$6F,$6F,$6F,$6F,$2F,$2F,$8F,$9F,$9F,$9E,$DE
.byte  $28,$28,$28,$28,$28,$28,$28,$A8,$A8,$A8,$A8,$A2,$A2,$A2,$A2,$A2
.byte  $FB,$F3,$F3,$F3,$F3,$F3,$F3,$F7,$F7,$F7,$F7,$FF,$FF,$FF,$E7,$E7
.byte  $FD,$F7,$E8,$8A,$96,$B4,$B4,$B4,$2D,$2B,$4A,$52,$52,$14,$35,$04
.byte  $21,$21,$20,$20,$21,$25,$25,$20,$A8,$A8,$A8,$A9,$89,$89,$09,$69
.byte  $28,$A8,$88,$A8,$88,$A8,$88,$A8,$8A,$AA,$8A,$AA,$AA,$8A,$A8,$8A
.byte  $A2,$A2,$A2,$AA,$AA,$AA,$AA,$8A,$8A,$08,$88,$21,$21,$A4,$84,$21
.byte  $40,$50,$10,$14,$90,$10,$18,$48,$01,$02,$A2,$08,$2A,$2A,$22,$22
.byte  $00,$73,$73,$72,$F2,$F2,$E0,$E0,$E4,$F4,$F5,$F5,$F5,$F4,$F4,$F5
.byte  $F5,$F5,$F5,$F5,$F5,$F9,$F9,$F9,$F9,$F9,$79,$79,$71,$71,$71,$31
.byte  $31,$7C,$3C,$3C,$3E,$3E,$3E,$2A,$2A,$2A,$2A,$2A,$2A,$32,$3E,$36
.byte  $20,$22,$34,$38,$38,$72,$72,$30,$30,$38,$38,$38,$30,$38,$30,$30
.byte  $70,$70,$30,$30,$30,$30,$30,$30,$32,$32,$30,$30,$10,$30,$30,$30
.byte  $70,$70,$30,$30,$30,$30,$30,$30,$32,$32,$30,$30,$10,$30,$30,$30
.byte  $CC,$CC,$DC,$CC,$EC,$EE,$CE,$DF,$DE,$DE,$DE,$DE,$DF,$DF,$FE,$DE
.byte  $FD,$FD,$FE,$7F,$3F,$3F,$BF,$BF,$1F,$4F,$C7,$E7,$A8,$A8,$39,$5A
.byte  $59,$9A,$98,$71,$EF,$D2,$B2,$62,$66,$05,$0F,$02,$12,$16,$54,$80
.byte  $10,$04,$01,$10,$40,$04,$40,$10,$01,$04,$10,$02,$AA,$AA,$AA,$A8
.byte  $A2,$A2,$8A,$2A,$AA,$AA,$A8,$A1,$06,$AA,$AA,$2A,$08,$00,$14,$00
.byte  $00,$80,$80,$00,$00,$00,$E0,$74,$00,$70,$30,$20,$40,$00,$81,$17
.byte  $07,$1F,$1F,$1F,$1F,$1F,$0F,$0F,$0F,$0F,$17,$17,$03,$83,$40,$00
.byte  $B0,$C0,$E4,$F2,$F8,$FC,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$FC,$FC,$FC,$FE,$F2,$F2,$F2
.byte  $C0,$C8,$C8,$C8,$C8,$28,$28,$2A,$AA,$AA,$AA,$2A,$0A,$42,$52,$10
.byte  $04,$80,$A1,$A8,$AA,$AA,$0A,$12,$52,$52,$42,$0A,$88,$A8,$A8,$AC
.byte  $08,$40,$54,$14,$84,$80,$A0,$A0,$A0,$A0,$A0,$A0,$80,$80,$80,$00
.byte  $02,$0A,$0A,$0A,$0A,$2A,$2A,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
.byte  $FF,$FF,$FF,$7F,$3F,$BF,$DF,$CF,$E7,$F7,$FB,$FB,$FD,$FC,$FE,$BE
.byte  $3F,$3F,$3F,$AF,$A7,$17,$13,$23,$61,$C5,$24,$86,$8E,$30,$63,$C1
.byte  $05,$01,$04,$11,$40,$01,$04,$50,$05,$51,$01,$A1,$A2,$20,$A8,$82
.byte  $A2,$84,$89,$98,$28,$62,$A0,$A0,$84,$80,$00,$04,$98,$80,$00,$00
.byte  $08,$19,$31,$23,$E3,$07,$00,$80,$00,$1E,$20,$64,$48,$48,$08,$00
.byte  $00,$46,$04,$00,$00,$80,$82,$C7,$F3,$F3,$F5,$F2,$FA,$F8,$F0,$41
.byte  $1B,$07,$07,$43,$00,$10,$44,$40,$41,$D0,$D0,$F8,$F0,$F0,$F0,$F2
.byte  $C0,$CA,$CA,$2A,$28,$28,$28,$29,$0A,$0A,$42,$82,$90,$A4,$A9,$0A
.byte  $12,$50,$50,$52,$52,$48,$08,$18,$68,$A8,$A8,$A0,$A0,$A0,$A0,$00
.byte  $12,$12,$0A,$4A,$4A,$4A,$4A,$4A,$4A,$2A,$2A,$2A,$2A,$AA,$AA,$AA
.byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
.byte  $AA,$A8,$A8,$A0,$A1,$A1,$A1,$81,$85,$85,$85,$85,$95,$94,$14,$14
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $7F,$3F,$BF,$9F,$DF,$CF,$EF,$F7,$F7,$F3,$FB,$FB,$7D,$7C,$7E,$3E
.byte  $3E,$3E,$1F,$DF,$CF,$CF,$8F,$67,$E7,$67,$07,$13,$33,$03,$01,$01
.byte  $21,$28,$28,$28,$28,$2A,$2A,$2A,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA
.byte  $7F,$3F,$3F,$BF,$BF,$9F,$1F,$1F,$0F,$07,$03,$01,$00,$00,$04,$00
.byte  $40,$70,$78,$FC,$FE,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$3E,$3E,$1E,$9C
.byte  $CC,$C8,$C8,$C0,$08,$00,$22,$22,$86,$00,$04,$26,$00,$00,$02,$52
.byte  $A5,$A8,$2A,$4A,$4A,$4A,$48,$28,$A8,$A8,$81,$20,$04,$04,$00,$00
.byte  $4A,$0A,$0A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$AA,$AA,$AA,$AA,$AA,$AA
.byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8,$A8,$A8,$A8,$A9,$A9
.byte  $A1,$A1,$A1,$A1,$85,$85,$85,$85,$15,$15,$14,$14,$14,$54,$54,$51
.byte  $FB,$FB,$F7,$F7,$F7,$E9,$EA,$DA,$DA,$D9,$BF,$BD,$7C,$FD,$FD,$FD
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $7F,$7F,$7F,$3F,$3F,$3F,$BF,$BF,$9F,$DF,$CF,$EF,$EF,$EF,$E7,$F7
.byte  $51,$51,$51,$51,$51,$14,$14,$14,$14,$14,$14,$14,$84,$84,$84,$84
.byte  $85,$85,$85,$85,$85,$85,$85,$85,$A5,$A1,$A1,$A1,$A1,$A1,$A1,$A1
.byte  $21,$21,$21,$01,$48,$48,$48,$48,$28,$28,$28,$28,$28,$08,$08,$08
.byte  $00,$04,$12,$8A,$8A,$00,$08,$28,$28,$60,$20,$60,$60,$20,$A0,$80
.byte  $48,$88,$48,$88,$28,$28,$28,$A8,$A8,$A1,$A1,$A1,$A1,$A1,$A1,$A1
.byte  $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1,$A5,$A5,$85,$85,$84,$84,$84
.byte  $3D,$3D,$3D,$3D,$3D,$79,$7B,$7B,$FB,$FB,$F7,$F7,$E7,$EF,$EF,$EF
.byte  $DF,$DF,$DF,$BF,$BF,$BF,$FF,$7F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$7F,$7F,$D2,$A4,$82,$A6,$A6,$FF,$55,$53,$53,$53,$6D
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$DF
.byte  $DF,$DF,$DF,$DF,$DF,$DF,$DF,$EF,$EF,$EF,$EF,$EF,$EF,$6F,$6F,$6F
.byte  $6F,$6F,$6F,$6F,$6F,$6F,$EF,$EF,$EF,$EF,$EF,$EF,$DF,$DF,$DF,$DF
.byte  $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF,$BF,$BF,$BF,$BF,$BF
.byte  $BF,$BF,$BF,$BF,$BF,$BF,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte  $FF,$FF,$DF,$EF,$FF,$4B,$97,$8B,$5D,$8B,$FF,$5B,$55,$11,$55,$55
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

screen_data2:

.byte  $10,$1C,$28,$34,$40,$4C,$58,$64
.byte  $70,$7C,$88,$94,$A0,$AC,$B8,$C4
.byte  $D0,$DC,$E8,$F4,$11,$1D,$29,$35
.byte  $41,$4D,$59,$65,$71,$7D,$89,$95
.byte  $A1,$AD,$B9,$C5,$D1,$DD,$E9,$F5
.byte  $12,$1E,$2A,$36,$42,$4E,$5A,$66
.byte  $72,$7E,$8A,$96,$A2,$AE,$BA,$C6
.byte  $D2,$DE,$EA,$F6,$13,$1F,$2B,$37
.byte  $43,$4F,$5B,$67,$73,$7F,$8B,$97
.byte  $A3,$AF,$BB,$C7,$D3,$DF,$EB,$F7
.byte  $14,$20,$2C,$38,$44,$50,$5C,$68
.byte  $74,$80,$8C,$98,$A4,$B0,$BC,$C8
.byte  $D4,$E0,$EC,$F8,$15,$21,$2D,$39
.byte  $45,$51,$5D,$69,$75,$81,$8D,$99
.byte  $A5,$B1,$BD,$C9,$D5,$E1,$ED,$F9
.byte  $16,$22,$2E,$3A,$46,$52,$5E,$6A
.byte  $76,$82,$8E,$9A,$A6,$B2,$BE,$CA
.byte  $D6,$E2,$EE,$FA,$17,$23,$2F,$3B
.byte  $47,$53,$5F,$6B,$77,$83,$8F,$9B
.byte  $A7,$B3,$BF,$CB,$D7,$E3,$EF,$FB
.byte  $18,$24,$30,$3C,$48,$54,$60,$6C
.byte  $78,$84,$90,$9C,$A8,$B4,$C0,$CC
.byte  $D8,$E4,$F0,$FC,$19,$25,$31,$3D
.byte  $49,$55,$61,$6D,$79,$85,$91,$9D
.byte  $A9,$B5,$C1,$CD,$D9,$E5,$F1,$FD
.byte  $1A,$26,$32,$3E,$4A,$56,$62,$6E
.byte  $7A,$86,$92,$9E,$AA,$B6,$C2,$CE
.byte  $DA,$E6,$F2,$FE,$1B,$27,$33,$3F
.byte  $4B,$57,$63,$6F,$7B,$87,$93,$9F
.byte  $AB,$B7,$C3,$CF,$DB,$E7,$F3,$FF

colour_data2:

.byte  $07,$07,$07,$07,$07,$0B,$07,$0B
.byte  $0C,$07,$0A,$0A,$07,$0D,$07,$07
.byte  $07,$07,$07,$07,$07,$07,$07,$0B
.byte  $0B,$0B,$0B,$0C,$0D,$0D,$0D,$0A
.byte  $0A,$05,$0D,$07,$07,$07,$07,$07
.byte  $07,$07,$0B,$03,$03,$03,$0B,$0F
.byte  $0F,$0F,$0D,$0D,$0D,$0C,$0D,$0D
.byte  $0D,$07,$07,$07,$07,$07,$0B,$03
.byte  $03,$03,$0B,$09,$09,$0F,$0F,$0F
.byte  $0F,$0A,$0D,$0D,$0D,$0B,$0B,$07
.byte  $07,$07,$03,$03,$03,$03,$0B,$0F
.byte  $0F,$0F,$0F,$0F,$0F,$0A,$0A,$07
.byte  $07,$03,$0B,$07,$07,$0B,$03,$03
.byte  $03,$03,$0B,$0A,$0F,$0F,$0F,$0F
.byte  $07,$07,$02,$07,$07,$03,$0B,$07
.byte  $07,$0B,$03,$03,$03,$03,$03,$0B
.byte  $0B,$0B,$0F,$0F,$0F,$0A,$02,$0F
.byte  $0F,$0C,$0C,$07,$07,$0B,$03,$03
.byte  $03,$03,$03,$03,$03,$03,$0B,$0F
.byte  $0F,$0A,$02,$0C,$0C,$0C,$0E,$07
.byte  $07,$07,$03,$03,$03,$03,$03,$03
.byte  $03,$03,$03,$0B,$0A,$02,$02,$0C
.byte  $0C,$0E,$0E,$07,$07,$07,$0B,$03
.byte  $03,$03,$03,$03,$03,$03,$03,$03
.byte  $0A,$02,$02,$0C,$0E,$0E,$07,$07
.byte  $07,$07,$07,$0B,$03,$03,$03,$03
.byte  $03,$03,$03,$0B,$0A,$0A,$02,$0C
.byte  $0E,$0E,$07,$07,$07,$07,$07,$0B
.byte  $03,$03,$03,$03,$03,$0B,$0B,$0A
.byte  $02,$02,$02,$0E,$0E,$07,$07,$07
.byte  $00