! $Id: set80col.s,v 1.0 2020/02/03 17:15:13 davide Exp $
!
! Set the screen to the 80 column configuration
! Implement the equivalent of the following BASIC program in assembler:
!
! 100 CALL "ss ,,,,1"

.global _set80col

    .z8001

    .data
ss:     .ascii  "ss"
c_1:    .ascii  "1"
sc_end:

sserrtxt: .asciz  "Cannot execute `ss`\r"

    .even
ptrwri: .word   1
ptrss:  .word   c_1-ss,ss

ptrn0:  .word   0xFF00,0xFFFF


    .text
    .even
 
!_main:
!    calr _set80col
!    ret

_set80col:
    calr    exec_ss
    cp  r5,#0       ! success?
    jr  ne,ssexecfail

exit:   
    clr r5      ! return status
    ret


ssexecfail:
    lda rr12,sserrtxt
err:    sc  #89
    jr  exit

! execute "ss ,,,,1"


exec_ss:
    ! program name
    push    @sp,#0x300  ! type 3 (string)
    lda rr2,ptrss+1
    pushl   @sp,rr2

    ! 1st parameter (none)
    push    @sp,#0x000  ! type 0 (null)
    lda rr2,ptrn0+1
    pushl   @sp,rr2
    
    ! 2nd parameter (none)
    push    @sp,#0x000  ! type 0 (null)
    lda rr2,ptrn0+1
    pushl   @sp,rr2
    
    ! 3rd parameter (none)
    push    @sp,#0x000  ! type 0 (null)
    lda rr2,ptrn0+1
    pushl   @sp,rr2

    ! 4th parameter (none)
    push    @sp,#0x000  ! type 0 (null)
    lda rr2,ptrn0
    pushl   @sp,rr2
        
    ! 5th parameter (1)
    push    @sp,#0x200  ! type 2 (integer)
    lda rr2,ptrwri
    pushl   @sp,rr2

    push    @sp,#5      ! # of parameters
    sc  #77     ! execute "ss ..."
    ret

    .end
