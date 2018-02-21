;******************************************************************************
;       hlas.asm
;
;       https://github.com/berk76/hlas
;       
;       Original author is unknown       
;       Disassembled by Jaroslav Beran <jaroslav.beran@gmail.com>, on 12.2.2018
;
;       How to compile:
; 
;       tasm hlas
;       tlink hlas /t
;
;******************************************************************************

.model tiny

.data

.code
        org 100h
start:

;************************
;* CPU Measure routine
;************************

        ;0040h:006Ch - Timer Counter
        ;When this value reaches midnight (1800B0h), it is reset to 0
        mov     ax,0040h        ;set segment of timer
        mov     es,ax
        mov     bx,006ch        ;set offset of timer
        xor     cx,cx           ;reset counter
        mov     al,es:[bx]      ;load current tick as reference

n01:    ;wait for start of next tick
        cmp     al,es:[bx]      ;check for one tick
        je      n01

        ;measure processor speed
        mov     al,es:[bx]      ;load current tick as reference
n02:
        inc     cx              ;increase counter
        cmp     al,es:[bx]      ;compare with current value
        je      n02             ;wait for next tick
        
        ;calculation of two constatns k1 and k2
        xor     dx,dx
        mov     ah,ch           ;high part of counter into ah
        mov     ch,04h          ;04OOh into cx
        xor     al,al
        mov     cl,al
        div     cx              ;ax / 1024
        mov     cx,ax           ;result into cx
        mov     al,[k1]         ;k1 (03h) into al
        mul     cl              ;result * 3
        mov     [k1],al         ;save k1

        mov     ax,[k2]         ;k2 (0d2h) into ax
        mul     cx              ;result * 210
        mov     [k2],ax         ;save k2
        jmp     n03

;************************
;* DATA
;************************

k1      db      03h
k2      dw      000d2h

;offset A of tbl01
tbl01   db      000h, 002h        ;AB
        db      006h, 00ah        ;CD
        db      00eh, 010h        ;EF
        db      012h, 016h        ;GH
        db      01ah, 01ch        ;IJ
        db      022h, 026h        ;KL
        db      02ah, 02eh        ;MN
        db      032h, 034h        ;OP
        db      038h, 042h        ;QR
        db      048h, 04ah        ;ST
        db      04eh, 050h        ;UV
        db      050h, 056h        ;WX
        db      01ah, 05ch        ;YZ
        db      064h, 066h
        db      070h, 074h
        db      07ah, 07ch
        db      0c2h, 084h
        db      086h, 0c2h
        db      0c2h, 0c2h
        db      088h, 08ch
        db      092h, 094h
        db      0c2h, 09eh
        db      0a6h, 0a8h
        db      0aeh, 0b0h
        db      0c2h, 0c2h
        db      086h, 0bch

tbl02   dw      08136h, 01934h
        dw      0ab31h, 01918h
        dw      0c391h, 01934h
        dw      0e031h, 08436h
        dw      0e392h, 01935h

        dw      09c51h, 03131h
        dw      09634h, 08736h
        dw      03a33h, 03d32h
        dw      0c032h, 01918h
        dw      09c51h, 02233h

        dw      0b131h, 03131h
        dw      0a536h, 03131h
        dw      0a836h, 08a36h
        dw      01918h, 0ab31h
        dw      01918h, 01c51h

        dw      03134h, 03432h
        dw      0b732h, 01022h
        dw      01913h, 0ae21h
        dw      0c392h, 01918h
        dw      0e031h, 08d36h

        dw      03134h, 03432h
        dw      0b732h, 01918h
        dw      01c71h, 0c392h
        dw      03132h, 04332h
        dw      04432h, 0c532h

        dw      0813fh, 01934h
        dw      02b31h, 03a33h
        dw      03d32h, 0c032h
        dw      01918h, 0d391h
        dw      01933h, 06d71h

        dw      09332h, 0843eh
        dw      06392h, 03a33h
        dw      03d32h, 0c032h
        dw      0f392h, 0873eh
        dw      03131h, 02536h

        dw      03131h, 02535h
        dw      09332h, 08a3eh
        dw      01918h, 02b31h
        dw      03a33h, 03d32h
        dw      0c032h, 01913h

        dw      06032h, 01913h
        dw      0dd71h, 0d392h
        dw      01918h, 06d71h
        dw      09332h, 08d3eh
        dw      03134h, 03432h

        dw      03732h, 03a33h
        dw      03d32h, 0c032h
        dw      05332h, 05432h
        dw      0d532h

tbl03   db      01ah, 099h
        db      0e1h, 0c3h
        db      0e1h, 0c7h
        db      08fh, 00fh
        db      0f8h, 003h
        db      00fh, 007h
        db      0c1h, 0e3h
        db      0ffh, 040h
        db      017h, 0ffh
        db      000h, 003h

        db      0f8h, 07ch
        db      0c1h, 0f1h
        db      0f8h, 003h
        db      0feh, 000h
        db      07fh, 0fch
        db      000h, 003h
        db      0f8h, 00fh
        db      009h, 0f1h
        db      0feh, 003h
        db      0efh, 040h

        db      017h, 0ffh
        db      000h, 003h
        db      0e1h, 05ch
        db      035h, 0c5h
        db      0aah, 035h
        db      000h, 000h
        db      000h, 000h
        db      000h, 000h
        db      03eh, 08eh
        db      038h, 073h

        db      0cfh, 0f8h
        db      078h, 0c3h
        db      0dfh, 01ch
        db      0f1h, 0c7h
        db      0feh, 003h
        db      0c0h, 0ffh
        db      000h, 000h
        db      0ffh, 0f8h
        db      000h, 07fh
        db      0f8h, 003h

        db      0ffh, 0f0h
        db      001h, 0ffh
        db      0e0h, 003h
        db      0aah, 0cah
        db      05ah, 0d5h
        db      021h, 03dh
        db      0feh, 01fh
        db      0f8h, 000h
        db      000h, 01fh
        db      0ffh, 0fch

        db      020h, 000h
        db      000h, 003h
        db      0ffh, 0ffh
        db      008h, 079h
        db      000h, 002h
        db      0ffh, 0e1h
        db      0c7h, 01fh
        db      0e0h, 003h
        db      0ffh, 0d0h
        db      001h, 0ffh

        db      0f0h, 003h
        db      07fh, 001h
        db      0fah, 05fh
        db      0c0h, 007h
        db      0f8h, 00fh
        db      0c0h, 0ffh
        db      000h, 042h
        db      0aah, 0a5h
        db      055h, 05ah
        db      0aah, 0aah

        db      05ah, 0a5h
        db      05ah, 0aah
        db      055h, 055h
        db      0aah, 0aah
        db      0a5h, 055h
        db      0aah, 05ah
        db      0aah, 0a5h
        db      055h, 0aah
        db      0aah, 0a5h
        db      055h, 0aah

        db      0aah, 055h
        db      0a5h, 0a5h
        db      0aah, 0a5h
        db      0b7h, 066h
        db      06ch, 0d8h
        db      0f9h, 0b3h
        db      06ch, 0adh
        db      037h, 037h
        db      066h, 0fch
        db      09bh, 087h

        db      0f6h, 0c0h
        db      0d3h, 0b6h
        db      060h, 0f7h
        db      0f7h, 03eh
        db      04dh, 0fbh
        db      0feh, 05dh
        db      0b7h, 0deh
        db      046h, 0f6h
        db      096h, 0b4h
        db      04fh, 0aah

        db      0a9h, 055h
        db      0aah, 0aah
        db      0a5h, 069h
        db      059h, 09ah
        db      06ah, 095h
        db      055h, 095h
        db      055h, 06ah
        db      0a5h, 055h
        db      0a9h, 04dh
        db      066h, 06ah

        db      092h, 0ech
        db      0a5h, 055h
        db      0d2h, 096h
        db      055h, 0a2h
        db      0bah, 0cdh
        db      000h, 066h
        db      099h, 0cch
        db      067h, 031h
        db      08eh, 066h
        db      039h, 0a6h

        db      06bh, 019h
        db      066h, 059h
        db      0c6h, 071h
        db      009h, 067h
        db      019h, 0cbh
        db      001h, 071h
        db      0cch, 073h
        db      019h, 099h
        db      0cch, 0c6h
        db      067h, 019h

        db      09ah, 0c6h
        db      059h

tbl04   db      000h, 02eh
        db      05ah, 05eh
        db      0feh, 000h
        db      000h, 000h

txt01   db      74 dup (' ')
        db      13,10,13,10,'$'

;************************
;* Main routine
;************************

n03:    ;probably info about program/author but cleared in my binary version
        ;can somebody provide original text ???
        mov     dx,offset txt01
        mov     ah,09
        int     21h

        ;check for cmd parameters
        mov     al,ds:[80h]     ;length of cmd parameters into al
        cmp     al,0
        jne     n04
        jmp     quit            ;quit program if no cmd parameters

n04:    ;put zero word at 81h-st position of cmd param
        xor     ah,ah
        add     ax,81h          ;80h + 81h
        mov     bx,ax           ;set pointer at 80h + 81h
        mov     byte ptr [bx+01],00h
        mov     byte ptr [bx],00h

        mov     bx,81h          ;ptr to the 1st. char of cmd param
        mov     ch,0bbh         ;set 0bbh as current char (0bbh stands for ch)

next_char:
        ;process next char        
        mov     cl,ch           ;save previous character
        mov     al,ch           ;save previous character

        mov     ch,[bx]         ;read current char from cmd string

        ;to upper case
        cmp     ch,61h          ;a letter
        jb      cmd_end_test    ;go to end of line test if less than a
        cmp     ch,7ah          ;z letter
        jg      cmd_end_test    ;go to end of line test if greater than z
        and     ch,0dfh         ;convert to upper character

cmd_end_test:
        ;end of line test
        or      al,al           ;zero test of previous character
        jne     n07
        jmp     quit            ;quit if zero

n07:    ;test if char is less than A
        mov     al,cl           ;restore previous char into al
        cmp     al,41h          ;A letter
        jnl     n08             ;jump if not less

no_alpha:
        ;no alphabet char
        jmp     no_alpha2

n08:
        cmp     al,5ah          ;Z letter
        jg      no_alpha

        ;test if current char is CH letter
        cmp     al,43h          ;C letter
        mov     al,ch           ;move curr char to al
        jne     n11
        cmp     al,48h          ;H letter
        je      ch_letter

n11:
        cmp     al,27h          ;' letter
        mov     al,cl           ;restore previous char into al
        jne     n13

ch_letter:
        ;set CH as current char
        add     al,1ah          ;(H)48h + 1ah = (b)62h ???
        mov     ch,0bbh         ;set CH as current char

n13:    ;call speaker
        push    cx
        push    bx
        call    play_letter
        pop     bx
        pop     cx

go_for_next_char:    
        ;go for next char
        inc     bx              ;move pointer to next char
        jmp     next_char       ;main loop

no_alpha2:
        ;no alphabet char
        push    cx
        mov     cx,00h          ;reset counter
        cmp     al,2eh          ;. letter
        je      no_alpha_delay 
        mov     cx,8000h
        cmp     al,2ch          ;, letter
        je      no_alpha_delay
        mov     cx,4000h
        cmp     al,20h          ;space
        jne     no_alpha_end

no_alpha_delay:
        nop
        nop
        loop    no_alpha_delay
    
no_alpha_end:
        pop     cx
        jmp     go_for_next_char

quit:   ;quit program
        sti                     ;set interrupt enable
        int     20h             ;terminates program execution

;************************
;* Play letter routine
;************************

play_letter:
        ;ascii is provided in al
        ;reading pointer to data from tbl01
        cli                     ;clear interrupt enable flag
        mov     bx,offset (tbl01 - 'A') ;set pointer to the begin of ASCII
        xor     ah,ah           
        add     bx,ax           ;add offset tbl01 + ascii
        mov     al,[bx]         ;read pointer to tbl02

        mov     bx,offset tbl02 ;set base pointer to tbl02
        add     bx,ax           ;add offset from ax

f09:    ;loop L0
        mov     ax,[bx]         ;read word from tbl02
                                ;------------------------
                                ;ax [abcd efgh ijkl mnop]
                                ;------------------------
                                ;a    = drives loop L0
                                ;mnop = number of cycles in loop L1
                                ;ijk  = offset in tbl04 (num of cycles in L2)
                                ;bcdefgh = offset in tbl03 (speaker on/off) 
                                ;------------------------
        and     al,0fh          ;al and 00001111b
        mov     cl,al           ;cl = [0000mnop]
        and     ah,80h          ;ah and 10000000b
        or      cl,ah           ;cl = [a000mnop]

f07:    ;loop L1 drived by cl reg.
        mov     ax,[bx]         ;read word from tbl02 again
        rol     al,01h          ;rotate left three times 
        rol     al,01h          ;bit that goes off is set to CF
        rol     al,01h          ;the same bit is inserted to right-most position
        and     al,07h          ;al and 00000111b [00000ijk]
        push    bx              ;save pointer to tbl02
        jne     f01             ;jump if not zero
        jmp     f02             ;otherwise wait about k2

f01:
        mov     bx,offset tbl04 ;set base pointer to tbl04
        xor     ah,ah
        add     bx,ax           ;add offset [00000ijk]
        mov     dl,[bx]         ;result into dl - number of cycles for L2
        pop     bx              ;restore pointer to tbl02
        mov     al,[bx+01]      ;load high part of word into al
        push    bx              ;save pointer to tbl02
        rcl     al,1            ;shift all bits left
                                ;the bit that goes off is set to CF
                                ;and previous value of CF is inserted to the 
                                ;right-most position
                                ;al = [bcdefgh0]
        mov     bx,offset tbl03 ;set base pointer to tbl03
        add     bx,ax
        mov     ah,80h          ;10000000b

f05:    ;loop L2 shaping sound according to tbl03
        ;length is given by dl reg. read from tbl04
        push    ax
        in      al,61h          ;8255 (port 61H) 
                                ;bit 0 controls the 8253 timer
                                ;bit 1 controls the speaker
        and     al,0fch         ;clear bit 0 and bit 1 (speaker off)
        and     ah,[bx]         ;10000000b and value from tbl03
        je      f03             ;leave speaker off if zero
        or      al,02h          ;set bit 0 and bit 1 (speaker on)

f03:
        out     61h,al          ;write to 8255

        mov     al,[k1]         ;wait k1 cycles

f04:
        dec     al
        jne     f04             ;waitning loop
        
        pop     ax
        dec     dl              ;decrement counter read from tbl04
        je      f02             ;jump if zero
        ror     ah,1            ;shift all bits right
                                ;the bit that goes off is set to CF
                                ;the same bit is inserted to left-most position
        jnb     f05             ;jump if CF=0
        inc     bx              ;increment pointer to tbl03
        jmp     f05             ;loop L2

f02:
        push    cx
        mov     cx,[k2]         ;wait k2 cycles

f06:
        loop    f06             ;waiting loop
        pop     cx
        
        dec     cl
        mov     al,cl
        and     al,0fh          ;and 00001111b
        pop     bx              ;restore pointer to tbl02
        jne     f07             ;loop L1 if not zero
        
        rol     cl,1            ;bit that goes off is set to CF
                                ;the same bit is inserted to right-most position
        jb      f08             ;jump if CF=1
        add     bx,02h          ;move tbl02 pointer to next word 
        jmp     f09             ;loop L0

f08:
        sti                     ;set interrupt enable
        ret

        end start
