ca65 V2.17 - Git N/A
Main file   : loader.s
Current file: loader.s

000000r 1                       PUTCH = $FFC9           ; Print the PETSCII char in A
000000r 1                       SETLFS = $FFBA          ; Set file parameters
000000r 1                       SETNAM = $FFBD          ; Set file name parameters
000000r 1                       LOAD = $FFD5            ; Load file
000000r 1                       CHKOUT = $FFC9          ; Set the default output device
000000r 1                       OPEN = $FFC0            ; Open a file
000000r 1                       SCREEN_BORDER = $FF19   ; Screen border
000000r 1                       LAST_OPENED_DEV = 174   ; Contains the last opened device
000000r 1               
000000r 1               
000000r 1                       FREEAREA = $02AD        ; Tiny little free memory area
000000r 1               
000000r 1               .export _doload
000000r 1               .import _prgnam
000000r 1               .import _namlen
000000r 1               
000000r 1               .importzp ptr1
000000r 1               
000000r 1               .segment "STARTUP"
000000r 1               .segment "LOWCODE"
000000r 1               .segment "INIT"
000000r 1               .segment "ONCE"
000000r 1               .segment "BSS"
000000r 1               .segment "CODE"
000000r 1               
000000r 1               
000000r 1               _doload:
000000r 1  A0 3B                    ldy #tinyloaderE-tinyloader
000002r 1  B9 rr rr     @loop:      lda tinyloader,y
000005r 1  99 AD 02                 sta FREEAREA,y
000008r 1  88                       dey
000009r 1  D0 F7                    bne @loop
00000Br 1  B9 rr rr                 lda tinyloader,y
00000Er 1  99 AD 02                 sta FREEAREA,y
000011r 1  A6 AE                    ldx LAST_OPENED_DEV ; Get the last opened device
000013r 1  D0 02                    bne @nozero         ; check if the device is zero
000015r 1  A2 08                    ldx #8              ; Default device to 8 if loader read from FLASH
000017r 1  A9 02        @nozero:    lda #2                  ; File logic number
000019r 1  A0 FF                    ldy #255                ; Secondary address (command)
00001Br 1  20 BA FF                 jsr SETLFS
00001Er 1  A9 02                    lda #2
000020r 1  8D 19 FF                 sta SCREEN_BORDER
000023r 1  A9 0B                    lda #(LoadNamE-LoadNam)   ; Filename length
000025r 1  A2 rr                    ldx #<LoadNam
000027r 1  A0 rr                    ldy #>LoadNam
000029r 1  20 BD FF                 jsr SETNAM
00002Cr 1  A9 02                    lda #2
00002Er 1  8D 19 FF                 sta SCREEN_BORDER
000031r 1  4C AD 02                 jmp FREEAREA
000034r 1               
000034r 1               
000034r 1               tinyloader:
000034r 1  A9 02                    lda #2
000036r 1  8D 19 FF                 sta SCREEN_BORDER
000039r 1  A9 00                    lda #0
00003Br 1  A2 FF                    ldx #$FF
00003Dr 1  A0 FF                    ldy #$FF
00003Fr 1  20 D5 FF                 jsr LOAD
000042r 1  B0 08                    bcs @error
000044r 1  A9 03                    lda #3
000046r 1  8D 19 FF                 sta SCREEN_BORDER
000049r 1                           ; Go in text mode here
000049r 1               
000049r 1  4C rr rr     @here:            jmp @here
00004Cr 1               
00004Cr 1  18           @error:      clc
00004Dr 1  69 30                    adc #48
00004Fr 1  20 C9 FF                 jsr PUTCH
000052r 1  A9 20                    lda #$20
000054r 1  20 C9 FF                 jsr PUTCH
000057r 1  A9 rr                    lda #<LoadErr
000059r 1  A0 rr                    ldy #>LoadErr
00005Br 1  20 rr rr                 jsr PrintStr
00005Er 1  A9 02                    lda #2
000060r 1  8D 19 FF                 sta SCREEN_BORDER
000063r 1  60                       rts
000064r 1  4C 4F 41 44  LoadErr:   .asciiz "load error"
000068r 1  20 45 52 52  
00006Cr 1  4F 52 00     
00006Fr 1               tinyloaderE:
00006Fr 1               
00006Fr 1               ; Print a string (null terminated) whose address is contained in A and
00006Fr 1               ; Y
00006Fr 1               
00006Fr 1  85 rr        PrintStr:   sta ptr1
000071r 1  84 rr                    sty ptr1+1
000073r 1  A0 00                    ldy #0
000075r 1  B1 rr        @loop:      lda (ptr1),Y
000077r 1  F0 07                    beq @exit
000079r 1  20 C9 FF                 jsr PUTCH
00007Cr 1  C8                       iny
00007Dr 1  4C rr rr                 jmp @loop
000080r 1  60           @exit:      rts
000081r 1               
000081r 1               
000081r 1  51 55 45 45  LoadNam:    .byte "queens-p4-1"
000085r 1  4E 53 2D 50  
000089r 1  34 2D 31     
00008Cr 1               LoadNamE:
00008Cr 1               
00008Cr 1               
