ca65 V2.17 - Git N/A
Main file   : loader.s
Current file: loader.s

000000r 1                       PUTCH = $FFD2           ; Print the PETSCII char in A
000000r 1                       SETLFS = $FFBA          ; Set file parameters
000000r 1                       SETNAM = $FFBD          ; Set file name parameters
000000r 1                       LOAD = $FFD5            ; Load file
000000r 1                       CHKOUT = $FFC9          ; Set the default output device
000000r 1                       OPEN = $FFC0            ; Open a file
000000r 1                       GETIN =  $FFE4          ; Get a key from the keyboard
000000r 1               
000000r 1                       ALTFONT = $0052         ; Use alternate font (=0) or not (=1)
000000r 1               
000000r 1                       FREEAREA = $02A7        ; Tiny little free memory area
000000r 1               
000000r 1                       STARTPROGRAM = 2061     ; Put 2061 (dec) for a normal program (no font)
000000r 1               
000000r 1               .export _doload
000000r 1               .export _choice
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
000000r 1               _choice:
000000r 1  A9 00                    lda #0
000002r 1  85 52                    sta ALTFONT
000004r 1               titlescreen:
000004r 1  A9 rr                    lda #<title
000006r 1  A0 rr                    ldy #>title
000008r 1  20 rr rr                 jsr PrintStr
00000Br 1  A5 52                    lda ALTFONT
00000Dr 1  F0 0A                    beq @ohyes
00000Fr 1  A9 rr                    lda #<no
000011r 1  A0 rr                    ldy #>no
000013r 1  20 rr rr                 jsr PrintStr
000016r 1  4C rr rr                 jmp @askkey
000019r 1               @ohyes:
000019r 1  A9 rr                    lda #<yes
00001Br 1  A0 rr                    ldy #>yes
00001Dr 1  20 rr rr                 jsr PrintStr
000020r 1               @askkey:                        ; Ask for a choice
000020r 1  20 rr rr                 jsr _cgetc40ch
000023r 1  C9 31                    cmp #'1'
000025r 1  F0 21                    beq @load1
000027r 1  C9 32                    cmp #'2'
000029r 1  F0 2D                    beq @load2
00002Br 1  C9 33                    cmp #'3'
00002Dr 1  F0 39                    beq @load3
00002Fr 1  C9 46                    cmp #'f'
000031r 1  F0 03                    beq @chosefont
000033r 1  4C rr rr                 jmp @askkey
000036r 1               @chosefont:
000036r 1  A5 52                    lda ALTFONT
000038r 1  F0 07                    beq @wr1
00003Ar 1  A9 00                    lda #0          ; Activate font
00003Cr 1  85 52                    sta ALTFONT
00003Er 1  4C rr rr                 jmp titlescreen
000041r 1  A9 01        @wr1:       lda #1
000043r 1  85 52                    sta ALTFONT
000045r 1  4C rr rr                 jmp titlescreen
000048r 1               @load1:
000048r 1  A9 0B                    lda #PrgName1E-PrgName1   ; Filename length
00004Ar 1  A2 rr                    ldx #<PrgName1
00004Cr 1  A0 rr                    ldy #>PrgName1
00004Er 1  8D rr rr                 sta LoadLen   ; Filename length
000051r 1  8E rr rr                 stx LoadNam+1
000054r 1  8C rr rr                 sty LoadNam
000057r 1  60                       rts
000058r 1               
000058r 1               @load2:
000058r 1  A9 0B                    lda #PrgName2E-PrgName2   ; Filename length
00005Ar 1  A2 rr                    ldx #<PrgName2
00005Cr 1  A0 rr                    ldy #>PrgName2
00005Er 1  8D rr rr                 sta LoadLen   ; Filename length
000061r 1  8E rr rr                 stx LoadNam+1
000064r 1  8C rr rr                 sty LoadNam
000067r 1  60                       rts
000068r 1               @load3:
000068r 1  A9 0B                    lda #PrgName3E-PrgName3   ; Filename length
00006Ar 1  A2 rr                    ldx #<PrgName3
00006Cr 1  A0 rr                    ldy #>PrgName3
00006Er 1  8D rr rr                 sta LoadLen   ; Filename length
000071r 1  8E rr rr                 stx LoadNam+1
000074r 1  8C rr rr                 sty LoadNam
000077r 1  60                       rts
000078r 1               
000078r 1               
000078r 1  A9 00        _doload:    lda #00             ; Main loader
00007Ar 1  8D 20 D0                 sta 53280
00007Dr 1  A0 57                    ldy #tinyloaderE-tinyloader
00007Fr 1  B9 rr rr     @loop:      lda tinyloader,y
000082r 1  99 A7 02                 sta FREEAREA,y
000085r 1  88                       dey
000086r 1  D0 F7                    bne @loop
000088r 1  B9 rr rr                 lda tinyloader,y
00008Br 1  99 A7 02                 sta FREEAREA,y
00008Er 1  A6 BA                    ldx 186             ; Get the last opened device
000090r 1  D0 02                    bne @nozero         ; check if the device is zero
000092r 1  A2 08                    ldx #8              ; Default device to 8 if loader read from FLASH
000094r 1  A9 02        @nozero:    lda #2                  ; File logic number
000096r 1  A0 FF                    ldy #255                ; Secondary address (command)
000098r 1  20 BA FF                 jsr SETLFS
00009Br 1  AD rr rr                 lda LoadLen
00009Er 1  AE rr rr                 ldx LoadNam+1
0000A1r 1  AC rr rr                 ldy LoadNam
0000A4r 1  20 BD FF                 jsr SETNAM
0000A7r 1  4C A7 02                 jmp FREEAREA
0000AAr 1               
0000AAr 1               tinyloader:
0000AAr 1  A9 00                    lda #0
0000ACr 1  A2 FF                    ldx #$FF
0000AEr 1  A0 FF                    ldy #$FF
0000B0r 1  20 D5 FF                 jsr LOAD
0000B3r 1  B0 0D                    bcs error
0000B5r 1  A9 03                    lda #3
0000B7r 1  8D 20 D0                 sta 53280
0000BAr 1  A9 C8                    lda #$c8
0000BCr 1  8D 16 D0                 sta $d016
0000BFr 1                           ;lda #200
0000BFr 1                           ;sta 53270
0000BFr 1  4C 0D 08                 jmp STARTPROGRAM
0000C2r 1               
0000C2r 1  18           error:      clc
0000C3r 1  69 30                    adc #48
0000C5r 1  20 D2 FF                 jsr PUTCH
0000C8r 1  A9 20                    lda #$20
0000CAr 1  20 D2 FF                 jsr PUTCH
0000CDr 1  A9 rr                    lda #<LoadErr
0000CFr 1  A0 rr                    ldy #>LoadErr
0000D1r 1  20 rr rr                 jsr PrintStr
0000D4r 1  A9 02                    lda #2
0000D6r 1  8D 20 D0                 sta 53280
0000D9r 1  A9 C8                    lda #200
0000DBr 1  8D 16 D0                 sta 53270
0000DEr 1  A9 15                    lda #21
0000E0r 1  8D 18 D0                 sta 53272
0000E3r 1  A9 1B                    lda #27
0000E5r 1  8D 11 D0                 sta 53265
0000E8r 1  A9 97                    lda #151
0000EAr 1  8D 00 DD                 sta 56576
0000EDr 1  A9 3F                    lda #63
0000EFr 1  8D 02 DD                 sta 56578
0000F2r 1               @stop:
0000F2r 1  4C rr rr                 jmp @stop
0000F5r 1  60                       rts
0000F6r 1  4C 4F 41 44  LoadErr:   .asciiz "load error"
0000FAr 1  20 45 52 52  
0000FEr 1  4F 52 00     
000101r 1               tinyloaderE:
000101r 1               
000101r 1               ; Print a string (null terminated) whose address is contained in A and
000101r 1               ; Y
000101r 1               
000101r 1  85 rr        PrintStr:   sta ptr1
000103r 1  84 rr                    sty ptr1+1
000105r 1  A0 00                    ldy #0
000107r 1  B1 rr        @loop:      lda (ptr1),Y
000109r 1  F0 07                    beq @exit
00010Br 1  20 D2 FF                 jsr PUTCH
00010Er 1  C8                       iny
00010Fr 1  4C rr rr                 jmp @loop
000112r 1  60           @exit:      rts
000113r 1               
000113r 1               ; Get a keystroke and return it in the A register
000113r 1               _cgetc40ch:
000113r 1               @loop:
000113r 1  20 E4 FF                 jsr GETIN       ; Last instruction is a TXA, Z flag is up to date
000116r 1  F0 FB                    beq @loop
000118r 1  60                       rts
000119r 1               
000119r 1               
000119r 1  00 00        LoadNam:    .byte 0,0
00011Br 1  00           LoadLen:    .byte 0
00011Cr 1  51 55 45 45  PrgName1:   .byte "queens-64-1"
000120r 1  4E 53 2D 36  
000124r 1  34 2D 31     
000127r 1               PrgName1E:
000127r 1  51 55 45 45  PrgName2:   .byte "queens-64-2"
00012Br 1  4E 53 2D 36  
00012Fr 1  34 2D 32     
000132r 1               PrgName2E:
000132r 1  51 55 45 45  PrgName3:   .byte "queens-64-3"
000136r 1  4E 53 2D 36  
00013Ar 1  34 2D 33     
00013Dr 1               PrgName3E:
00013Dr 1               
00013Dr 1  93 0D 0D 20  title:      .byte 147,13,13,"      The Queen's Footsteps",13
000141r 1  20 20 20 20  
000145r 1  20 D4 48 45  
00015Cr 1  20 20 20 20              .byte       "      ---------------------",13,13
000160r 1  20 20 2D 2D  
000164r 1  2D 2D 2D 2D  
000179r 1  20 20 20 20              .byte       "        Select:",13,13
00017Dr 1  20 20 20 20  
000181r 1  D3 45 4C 45  
00018Ar 1  20 20 20 20              .byte       "      [1] - Part 1",13
00018Er 1  20 20 5B 31  
000192r 1  5D 20 2D 20  
00019Dr 1  20 20 20 20              .byte       "      [2] - Part 2",13
0001A1r 1  20 20 5B 32  
0001A5r 1  5D 20 2D 20  
0001B0r 1  20 20 20 20              .byte       "      [3] - Parts 3 and 4",13,13
0001B4r 1  20 20 5B 33  
0001B8r 1  5D 20 2D 20  
0001CBr 1  20 20 20 20              .byte       "      [F] - Art Nouveau 64 font: "
0001CFr 1  20 20 5B C6  
0001D3r 1  5D 20 2D 20  
0001ECr 1  00                       .byte 0
0001EDr 1  D9 C5 D3 00  yes:        .byte       "YES",0
0001F1r 1  CE CF 00     no:         .byte       "NO",0
0001F3r 1               
