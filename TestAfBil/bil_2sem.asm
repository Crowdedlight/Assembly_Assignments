rjmp	SETUP     	;  0x00000054

ldi r16, 0x00	; 80    Sat to zero to not run until command is given
out 0x23, r16	; 35

SETUP:
ldi	r16, 0x08	; 8
out	0x3e, r16	; 62
ldi	r16, 0x5F	; 95
out	0x3d, r16	; 61
ldi	r16, 0x80	; 128
sbi	0x11, 7	    ; 17
cbi	0x12, 7	    ; 18
;ldi r16, 0x00	; 80    Sat to zero to not run until command is given
;out 0x23, r16	; 35
ldi	r16, 0x6A	; 106
out	0x25, r16	; 37
ldi	r17, 0x00	; 0
ldi	r16, 0xCF	; 207
out	0x20, r17	; 32
out	0x09, r16	; 9
sbi	0x0b, 1	    ; 11
ldi	r16, 0x86	; 134
out	0x20, r16	; 32
ldi	r16, 0x18	; 24
out	0x0a, r16	; 10
ldi	r16, 0x32	; 50
out	0x0c, r16	; 12

SBIS:
sbis	0x0b, 7	; 11
rjmp	SBIS    ;  0x00000080

in	r16, 0x0c	; 12
out	0x0c, r16	; 12

cpi	r16, 0x30	; 48
breq	 ZERO     	;  0x00000096

cpi r16, 0x31   ; 49
breq     ONE

cpi r16, 0x32   ; 50
breq     TWO

cpi r16, 0x33   ; 51
breq     THREE

cpi r16, 0x34   ; 52
breq     FOUR

cpi	r16, 0x35	; 53
breq	 FIVE     	;  0x0000009a

cpi r16, 0x36   ; 54
breq     SIX

cpi r16, 0x37   ; 55
breq     SEVEN

cpi r16, 0x38   ; 56
breq     EIGHT

cpi	r16, 0x39	; 57
breq	 NINE     	;  0x0000009e

cpi r16, 0x2B   ; 43 "+" Full Speed
breq     TEN

rjmp	 SBIS     	;  0x00000080

ZERO:
ldi	r16, 0x00	; 0
rjmp	 SEND      	;  0x000000a0

ONE:
ldi r16, 0x19   ; 25 - 10%
rjmp     SEND

TWO:
ldi r16, 0x33   ; 51 - 20%
rjmp     SEND

THREE:
ldi r16, 0x4c   ; 76 - 30%
rjmp     SEND

FOUR:
ldi r16, 0x66   ; 102 - 40%
rjmp     SEND

FIVE:
ldi	r16, 0x7F	; 127
rjmp	 SEND      	;  0x000000a0

SIX:
ldi r16, 0x99   ; 153 -60%
rjmp     SEND

SEVEN:
ldi r16, 0xB2   ; 178 - 70%
rjmp     SEND

EIGHT:
ldi r16, 0xCC   ; 204 - 80%
rjmp     SEND

NINE:
ldi	r16, 0xE5	; 229
rjmp     SEND       ; Jump to send

TEN:
ldi r16, 0xFF   ; 255 FULL SPEED
rjmp     SEND

SEND:
out	0x23, r16	; 35

rjmp	SBIS     	;  0x00000080
rjmp	SBIS     	;  0x00000080
