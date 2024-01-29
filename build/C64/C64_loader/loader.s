        PUTCH = $FFD2           ; Print the PETSCII char in A
        SETLFS = $FFBA          ; Set file parameters
        SETNAM = $FFBD          ; Set file name parameters
        LOAD = $FFD5            ; Load file
        CHKOUT = $FFC9          ; Set the default output device
        OPEN = $FFC0            ; Open a file
        GETIN =  $FFE4          ; Get a key from the keyboard

        ALTFONT = $0052         ; Use alternate font (=0) or not (=1)

        FREEAREA = $02A7        ; Tiny little free memory area

        STARTPROGRAM = 2061     ; Put 2061 (dec) for a normal program (no font)
            
.export _doload
.export _choice
.import _prgnam
.import _namlen

.importzp ptr1

.segment "STARTUP"
.segment "LOWCODE"
.segment "INIT"
.segment "ONCE"
.segment "BSS"
.segment "CODE"

_choice:
            lda #0
            sta ALTFONT
titlescreen:
            lda #<title
            ldy #>title
            jsr PrintStr
            lda ALTFONT
            beq @ohyes
            lda #<no
            ldy #>no
            jsr PrintStr
            jmp @askkey
@ohyes:
            lda #<yes
            ldy #>yes
            jsr PrintStr
@askkey:                        ; Ask for a choice
            jsr _cgetc40ch
            cmp #'1'
            beq @load1
            cmp #'2'
            beq @load2
            cmp #'3'
            beq @load3
            cmp #'f'
            beq @chosefont
            jmp @askkey
@chosefont:
            lda ALTFONT
            beq @wr1
            lda #0          ; Activate font
            sta ALTFONT
            jmp titlescreen
@wr1:       lda #1
            sta ALTFONT
            jmp titlescreen
@load1:
            lda #PrgName1E-PrgName1   ; Filename length
            ldx #<PrgName1
            ldy #>PrgName1
            sta LoadLen   ; Filename length
            stx LoadNam+1
            sty LoadNam
            rts

@load2:     
            lda #PrgName2E-PrgName2   ; Filename length
            ldx #<PrgName2
            ldy #>PrgName2
            sta LoadLen   ; Filename length
            stx LoadNam+1
            sty LoadNam
            rts
@load3:     
            lda #PrgName3E-PrgName3   ; Filename length
            ldx #<PrgName3
            ldy #>PrgName3
            sta LoadLen   ; Filename length
            stx LoadNam+1
            sty LoadNam
            rts


_doload:    lda #00             ; Main loader
            sta 53280
            ldy #tinyloaderE-tinyloader
@loop:      lda tinyloader,y
            sta FREEAREA,y
            dey
            bne @loop
            lda tinyloader,y
            sta FREEAREA,y
            ldx 186             ; Get the last opened device
            bne @nozero         ; check if the device is zero
            ldx #8              ; Default device to 8 if loader read from FLASH
@nozero:    lda #2                  ; File logic number
            ldy #255                ; Secondary address (command)
            jsr SETLFS
            lda LoadLen
            ldx LoadNam+1
            ldy LoadNam
            jsr SETNAM
            jmp FREEAREA

tinyloader:
            lda #0
            ldx #$FF
            ldy #$FF
            jsr LOAD
            bcs error
            lda #3
            sta 53280
            lda #$c8 
            sta $d016
            ;lda #200
            ;sta 53270
            jmp STARTPROGRAM
            
error:      clc
            adc #48
            jsr PUTCH
            lda #$20
            jsr PUTCH
            lda #<LoadErr
            ldy #>LoadErr
            jsr PrintStr
            lda #2
            sta 53280
            lda #200
            sta 53270
            lda #21
            sta 53272
            lda #27
            sta 53265
            lda #151
            sta 56576
            lda #63
            sta 56578
@stop:      
            jmp @stop
            rts
LoadErr:   .asciiz "load error"
tinyloaderE:

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

; Get a keystroke and return it in the A register
_cgetc40ch:
@loop:
            jsr GETIN       ; Last instruction is a TXA, Z flag is up to date
            beq @loop
            rts


LoadNam:    .byte 0,0
LoadLen:    .byte 0
PrgName1:   .byte "queens-64-1"
PrgName1E:
PrgName2:   .byte "queens-64-2"
PrgName2E:
PrgName3:   .byte "queens-64-3"
PrgName3E:

title:      .byte 147,13,13,"      The Queen's Footsteps",13
            .byte       "      ---------------------",13,13
            .byte       "        Select:",13,13
            .byte       "      [1] - Part 1",13
            .byte       "      [2] - Part 2",13
            .byte       "      [3] - Parts 3 and 4",13,13
            .byte       "      [F] - Art Nouveau 64 font: "
            .byte 0
yes:        .byte       "YES",0
no:         .byte       "NO",0