.include "m32def.inc"

;Initialisér programmet

RESET:

    ; PORTC setup

    ldi				R16,		0x00				; Read input into R16
    out				DDRC,		R16					; Set PORTC as input
    ldi				R16,		255					; Set Pull-up value in R16 (Max value in decimal)
    out 			PORTC,	R16 				; Enable pull-up on PORTC

    ; PORTB setup

    ldi				R16,		0xFF				; Set output value in R16
    out			 	DDRB,		R16 				; PORTB = output


;Start programløkken

; Sætter variable

.equ seg0=0b10100000
.equ seg1=0b11110011
.equ seg2=0b10010100
.equ seg3=0b10010001
.equ seg4=0b11000011
.equ seg5=0b10001001
.equ seg6=0b10001000
.equ seg7=0b10110011
.equ seg8=0b10000000
.equ segE=0b10001100



LOOP:

    in 			  R16,		PINC        ; Read value from switch
    com       R16
    cpi       R16,    0b00000000  ; sammenlign om ingen er tændt      ;
    breq      NUL                 ; hop til 0 hvis ingen er tændt

    cpi       R16,    0b00000001  ; sammenlign om switch 1 er tændt
    breq      ET

    cpi       R16,    0b00000010  ; sammenlign om switch 2 er tændt
    breq      TO

    cpi       R16,    0b00000100  ; sammenlign om switch 3 er tændt
    breq      TRE

    cpi       R16,    0b00001000  ; sammenlign om switch 4 er tændt
    breq      FIRE

    cpi       R16,    0b00010000  ; sammenlign om switch 5 er tændt
    breq      FEM

    cpi       R16,    0b00100000  ; sammenlign om switch 6 er tændt
    breq      SEKS

    cpi       R16,    0b01000000  ; sammenlign om switch 7 er tændt
    breq      SYV

    cpi       R16,    0b10000000  ; sammenlign om switch 8 er tændt
    breq      OTTE

    ldi       R16,    segE        ; Hvis ingen af sammenligningerne passer må flere være tændt og derfor ERROR
    out       PORTB,  R16

    rjmp LOOP

NUL:

    ldi       R16,    seg0
    out       PORTB,  R16

    rjmp LOOP

ET:
    ldi       R16,    seg1
    out       PORTB,  R16

    rjmp LOOP

TO:
    ldi       R16,    seg2
    out       PORTB,  R16

    rjmp LOOP

TRE:
    ldi       R16,    seg3
    out       PORTB,  R16

    rjmp LOOP

FIRE:
    ldi       R16,    seg4
    out       PORTB,  R16

    rjmp LOOP

FEM:
    ldi       R16,    seg5
    out       PORTB,  R16

    rjmp LOOP

SEKS:
    ldi       R16,    seg6
    out       PORTB,  R16

    rjmp LOOP

SYV:
    ldi       R16,    seg7
    out       PORTB,  R16

    rjmp LOOP

OTTE:
    ldi       R16,    seg8
    out       PORTB,  R16

    rjmp LOOP
