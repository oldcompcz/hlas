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
;010D
n01:    ;wait for start of next tick
        cmp     al,es:[bx]      ;check for one tick
        je      n01
        
        ;measure processor speed
        mov     al,es:[bx]      ;load current tick as reference
;0115
n02:
        inc     cx              ;increase counter
        cmp     al,es:[bx]      ;compare with current value
        je      n02             ;wait for next tick
        
        ;calculation of two constatns var01 and var02
        ;needs to be explained ???
        xor     dx,dx
        mov     ah,ch
        mov     ch,04h
        xor     al,al
        mov     cl,al
        div     cx
        mov     cx,ax
        mov     al,[k1]
        mul     cl
        mov     [k1],al
        mov     ax,[k2]
        mul     cx
        mov     [k2],ax
        jmp     n03

;************************
;* DATA
;************************

;013C
k1      db      03h

;013D
k2      dw      000d2h

;013F
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
        
;0173
tbl02   db      036h, 081h, 034h, 019h
        db      031h, 0abh, 018h, 019h
        db      091h, 0c3h, 034h, 019h 
        db      031h, 0e0h, 036h, 084h
        db      092h, 0e3h, 035h, 019h

        db      051h, 09ch, 031h, 031h
        db      034h, 096h, 036h, 087h
        db      033h, 03ah, 032h, 03dh
        db      032h, 0c0h, 018h, 019h
        db      051h, 09ch, 033h, 022h

        db      031h, 0b1h, 031h, 031h
        db      036h, 0a5h, 031h, 031h
        db      036h, 0a8h, 036h, 08ah
        db      018h, 019h, 031h, 0abh
        db      018h, 019h, 051h, 01ch

        db      034h, 031h, 032h, 034h
        db      032h, 0b7h, 022h, 010h
        db      013h, 019h, 021h, 0aeh
        db      092h, 0c3h, 018h, 019h
        db      031h, 0e0h, 036h, 08dh

        db      034h, 031h, 032h, 034h
        db      032h, 0b7h, 018h, 019h
        db      071h, 01ch, 092h, 0c3h
        db      032h, 031h, 032h, 043h
        db      032h, 044h, 032h, 0c5h

        db      03fh, 081h, 034h, 019h
        db      031h, 02bh, 033h, 03ah
        db      032h, 03dh, 032h, 0c0h
        db      018h, 019h, 091h, 0d3h
        db      033h, 019h, 071h, 06dh

        db      032h, 093h, 03eh, 084h
        db      092h, 063h, 033h, 03ah
        db      032h, 03dh, 032h, 0c0h
        db      092h, 0f3h, 03eh, 087h
        db      031h, 031h, 036h, 025h

        db      031h, 031h, 035h, 025h
        db      032h, 093h, 03eh, 08ah
        db      018h, 019h, 031h, 02bh
        db      033h, 03ah, 032h, 03dh
        db      032h, 0c0h, 013h, 019h

        db      032h, 060h, 013h, 019h
        db      071h, 0ddh, 092h, 0d3h
        db      018h, 019h, 071h, 06dh
        db      032h, 093h, 03eh, 08dh
        db      034h, 031h, 032h, 034h

        db      032h, 037h, 033h, 03ah
        db      032h, 03dh, 032h, 0c0h
        db      032h, 053h, 032h, 054h
        db      032h, 0d5h

;0235
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

;033C
tbl04   db      000h, 02eh
        db      05ah, 05eh
        db      0feh, 000h
        db      000h, 000h

;0344   
txt01   db      74 dup (' ')
        db      13,10,13,10,'$'
        
;************************
;* Main routine
;************************

;0393   
n03:    ;probably info about program/author but cleared in my binary version
        ;can somebody provide original text ???
        mov     dx,offset txt01
        mov     ah,09
        int     21h
        
        ;check for cmd parameters
        mov     al,ds:[80h]     ;length of cmd parameters
        cmp     al,0
        jne     n04
        jmp     quit            ;quit program if no cmd parameters

;03A4        
n04:    ;put zero word at 81h-st position of cmd param
        xor     ah,ah
        add     ax,81h          ;80h + 81h
        mov     bx,ax           ;set pointer
        mov     byte ptr [bx+01],00h
        mov     byte ptr [bx],00h
        
        mov     bx,81h          ;ptr to the 1st. char of cmd param
        mov     ch,0bbh         ;set CH letter as current char
;03B7    
next_char:
        ;process next char        
        mov     cl,ch           ;save previous character
        mov     al,ch           ;save previous character
        
        mov     ch,[bx]         ;read char from cmd string
        
        ;to upper case
        cmp     ch,61h          ;a letter
        jb      cmd_end_test    ;go to end str end test if below
        cmp     ch,7ah          ;z letter
        jg      cmd_end_test    ;go to end str end test if greater
        and     ch,0dfh         ;convert to upper
;03CA    
cmd_end_test:    
        ;test for end of cmd param string
        or      al,al           ;zero test of previous character
        jne     n07
        jmp     quit            ;quit if zero
;03D1    
n07:    ;test if char is less than A
        mov     al,cl           ;restore previous char into al
        cmp     al,41h          ;A letter
        jnl     n08             ;jump if not less
;03D7
no_alpha:
        ;no alphabet char        
        jmp     no_alpha2
;03DA    
n08:        
        cmp     al,5ah          ;Z letter
        jg      no_alpha
        
        ;test for CH letter
        cmp     al,43h          ;C letter
        mov     al,ch           ;move curr char to al
        jne     n11
        cmp     al,48h          ;H letter
        je      ch_letter
;03E8
n11:        
        cmp     al,27h          ;' letter
        mov     al,cl           ;restore previous char into al
        jne     n13
;03EE
ch_letter:    
        ;set ch as current char    
        add     al,1ah          ;(H)48h + 1ah = (b)62h ???
        mov     ch,0bbh         ;set CH as current char
;03F2    
n13:    ;call speaker    
        push    cx
        push    bx
        call    play_letter
        pop     bx
        pop     cx
;03F9    
go_for_next_char:    
        ;go for next char    
        inc     bx              ;move pointer to next char
        jmp     next_char       ;main loop
         
;03FC    
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
;0412    
no_alpha_delay:        
        nop
        nop
        loop    no_alpha_delay
;0416    
no_alpha_end:
        pop     cx
        jmp     go_for_next_char
        
;0419    
quit:   ;quit program
        sti                     ;set interrupt enable
        int     20h             ;terminates program execution

;************************
;* Play letter routine
;************************

;041C    
play_letter:
        cli                     ;clear interrupt enable flag
        mov     bx,offset (tbl01 - 'A') ;set pointer to 00FEh
        xor     ah,ah
        add     bx,ax           ;ascii in al 
                                ;00FE + 'A'(41) = 013F
                                ;00FE + 'Z'(5A) = 0158
                                ;00FE + 'b'(62) = 0160
        mov     al,[bx]         ;read offset into al
        mov     bx,offset tbl02 ;set pointer to 0173h
        add     bx,ax           ;add offset from ax
;042B
f09:        
        mov     ax,[bx]
        and     al,0fh          ;clear upper 4 bits
        mov     cl,al
        and     ah,80h
        or      cl,ah
;0436
f07:
        mov     ax,[bx]
        rol     al,1
        rol     al,1
        rol     al,1
        and     al,07
        push    bx
        jne     f01
        jmp     f02
;0446
f01:
        mov     bx,offset tbl04
        xor     ah,ah
        add     bx,ax
        mov     dl,[bx]
        pop     bx
        mov     al,[bx+01]
        push    bx
        rcl     al,1
        mov     bx,offset tbl03
        add     bx,ax
        mov     ah,80h
;045D
f05:
        push    ax
        in      al,61h          ;8255 (port 61H) 
                                ;bit 0 controls the 8253 timer
                                ;bit 1 controls the speaker
        and     al,0fch         ;clear bit 0 and bit 1 (speaker off)
        and     ah,[bx]
        je      f03             ;leave speaker off
        or      al,02h          ;set bit 0 and bit 1 (speaker on)
;0468
f03:
        out     61h,al          ;write to 8255
        
        ;wait k1 period
        mov     al,[k1]
;046D
f04:
        dec     al
        jne     f04
        
        pop     ax
        dec     dl
        je      f02
        ror     ah,1
        jnb     f05
        inc     bx
        jmp     f05
          
;047d
f02:    
        push    cx
        mov     cx,[k2]
;0482
f06:
        loop    f06
        pop     cx
        dec     cl
        mov     al,cl
        and     al,0fh
        pop     bx
        jne     f07
        rol     cl,1
        jb      f08
        add     bx,02h
        jmp     f09
;0497
f08:
        sti                     ;set interrupt enable
        ret
            
        end start
