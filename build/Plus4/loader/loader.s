        PUTCH = $FFD2           ; Print the PETSCII char in A
        SETLFS = $FFBA          ; Set file parameters
        SETNAM = $FFBD          ; Set file name parameters
        LOAD = $FFD5            ; Load file
        OPEN = $FFC0            ; Open a file
        SCREEN_BORDER = $FF19   ; Screen border
        LAST_OPENED_DEV = 174   ; Contains the last opened device
        START_ADDRESS = 4109    ; Start address of the file to load

        ENABLE_ROM = $FF3E
        ENABLE_RAM = $FF3F
        
        FONT_DEST = $F000

        FREEAREA = $0200        ; We invade the Basic buffer.

.export _doload
.import _prgnam
.import _namlen
.import charset

.importzp ptr1

.segment "STARTUP"
.segment "LOWCODE"
.segment "INIT"
.segment "ONCE"
.segment "BSS"
.segment "CODE"


_doload:    
            jsr delay
            jsr delay
            jsr delay
            jsr delay
            jsr delay
            jsr delay
            jsr copyfont
            lda $FF06          ; Switch off the screen
            and #$EF
            sta $FF06
            ldy #tinyloaderE-tinyloader
@loop:      lda tinyloader,y
            sta FREEAREA,y
            dey
            bne @loop
            lda tinyloader,y
            sta FREEAREA,y
            ldx LAST_OPENED_DEV ; Get the last opened device
            bne @nozero         ; check if the device is zero
            ldx #8              ; Default device to 8 if loader read from FLASH
@nozero:    lda #2                  ; File logic number
            ldy #255                ; Secondary address (command)
            sta ENABLE_ROM
            jsr SETLFS
            sta ENABLE_RAM
            
            lda #(LoadNamE-LoadNam)   ; Filename length
            ldx #<LoadNam
            ldy #>LoadNam
            sta ENABLE_ROM
            jsr SETNAM
            ;sta ENABLE_RAM
            jmp FREEAREA

copyfont:   sta ENABLE_RAM
            ldy #$00
@llo:
            lda charset,Y
            sta FONT_DEST,Y
            lda charset+    1*$100,Y
            sta FONT_DEST+  1*$100,Y
            lda charset+    2*$100,Y
            sta FONT_DEST+  2*$100,Y
            lda charset+    3*$100,Y
            sta FONT_DEST+  3*$100,Y
            lda charset+    0*$100,Y
            sta FONT_DEST+  4*$100,Y
            lda charset+    1*$100,Y
            sta FONT_DEST+  5*$100,Y
            lda charset+    2*$100,Y
            sta FONT_DEST+  6*$100,Y
            lda charset+    3*$100,Y
            sta FONT_DEST+  7*$100,Y
            dey
            bne @llo
            rts

tinyloader:
            lda #0
            ldx #$FF
            ldy #$FF
            jsr LOAD
            sta ENABLE_RAM
            bcs @error
            ldx #27         ; Back to normal text mode
            stx $FF06
            ldx #$8
            stx $FF07
            stx $FF14
            lda #$c0        ; Put the ch. gen RAM at $F000
            sta $ff12 
            lda #$f2
            sta $ff13 
            lda #$80        ; Disable C= + SHIFT
            sta $0547
            lda #$00        ; Screen Background: black
            sta $FF15
            jmp START_ADDRESS
@error:     jmp ShowError
tinyloaderE:

ShowError:
            ldx #2
            stx SCREEN_BORDER
            ldx #27         ; Back to normal text mode
            stx $FF06
            ldx #$c0
            stx $FF12
            ldx #$f2
            stx $FF13
            ldx #$8
            stx $FF14
            clc
            adc #48
            sta ENABLE_ROM
            jsr PUTCH
            lda #$20
            jsr PUTCH
            sta ENABLE_RAM
            lda #<LoadErr
            ldy #>LoadErr
            jsr PrintStr
            sec
@here:  bcs @here
LoadErr:   .asciiz "load error"



delay:
            ldx #$FF
            ldy #$FF
@ll:        dey
            bne @ll
            dex
            bne @ll
            rts

; Print a string (null terminated) whose address is contained in A and
; Y

PrintStr:   sta ptr1
            sty ptr1+1
            ldy #0
@loop:      lda (ptr1),Y
            beq @exit
            sta ENABLE_ROM
            jsr PUTCH
            sta ENABLE_RAM
            iny
            jmp @loop
@exit:      rts


LoadNam:    .byte "queens-p4"
LoadNamE: