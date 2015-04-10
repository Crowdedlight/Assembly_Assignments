.include "m32def.inc"

;SETUP

SETUP:

    ; PORTB setup

    ldi				R16,		0xFF				; Set output value in R16
    out			 	DDRB,		R16 				; PORTB = output

    ; PORTD Setup

    ldi             R16,        0x00                ; Read input into R16
    out             DDRD,       R16                 ; Set PORTD as input
    ldi             R16,        255                 ; Set Pull-up value in R16
    out             PORTD,      R16                 ; Enable pull-up

    ; Stack Init

    ldi             R16,        HIGH(RAMEND)        ; Starting Stack
    out             SPH,        R16
    ldi             R16,        LOW(RAMEND)
    out             SPL,        R16


; Setting Variables

.def NumLSB=R26
.def NumMSB=R27
.def SecondNumLSB=R16
.def SecondNumMSB=R17
.def Denominator=R21
.def QuotLSB=R30
.def QuotMSB=R31

MAIN:
