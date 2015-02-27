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
.equ seg2=0b00010100
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
    ldi       R17,    0xFF        ; Set MSB to 1
    and       R16,    R17
    brne      DOT
    ldi       R16,    0xFF
    out       PORTB,  R16
    rjmp      LOOP


DOT:
    ldi       R16,    segdot
    out       PORTB,  R16
    rjmp      LOOP
