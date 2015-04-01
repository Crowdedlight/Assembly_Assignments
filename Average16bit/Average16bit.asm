.include "m32def.inc"

;SETUP

SETUP:

    ; PORTC setup

    ldi				R16,		0x00				; Read input into R16
    out				DDRC,		R16					; Set PORTC as input
    ldi				R16,		255					; Set Pull-up value in R16 (Max value in decimal)
    out 			PORTC,   	R16 				; Enable pull-up on PORTC

    ; PORTB setup

    ldi				R16,		0xFF				; Set output value in R16
    out			 	DDRB,		R16 				; PORTB = output

    ; PORTD Setup

    ldi             R16,        0x00
    out             DDRD,       R16
    ldi             R16,        255
    out             PORTD,      R16

    ; Stack Init

    ldi             R16,        HIGH(RAMEND)        ; Starting Stack
    out             SPH,        R16
    ldi             R16,        LOW(RAMEND)
    out             SPL,        R16


; Setting Variables

.def FirstNumLSB=R26
.def FirstNumMSB=R30
.def SecondNumLSB=R16
.def SecondNumMSB=R17
.def Denominator=R20
.def QuotLSB=R24
.def QuotMSB=R28
.def BtnValue=R18

MAIN:

    ldi         FirstNumLSB,    Low(2655)
    ldi         FirstNumMSB,    High(2655)

    ldi         SecondNumLSB,   Low(74)
    ldi         SecondNumMSB,   High(74)

    call        SUM16

    ldi         SecondNumLSB,   Low(592)
    ldi         SecondNumMSB,   High(592)

    call        SUM16

    ldi         SecondNumLSB,   Low(1380)
    ldi         SecondNumMSB,   High(1380)

    call        SUM16

    ldi         SecondNumLSB,   Low(17352)
    ldi         SecondNumMSB,   High(17352)

    call        SUM16

    call        DIV16_8

    com         QuotLSB
    com         QuotMSB
    com         FirstNumLSB

    rjmp PRINT_DIODE

SUM16:

    add         FirstNumLSB,    SecondNumLSB
    adc         FirstNumMSB,    SecondNumMSB

    ret


DIV16_8:
    ldi         Denominator,    5
    clr         QuotLSB
    clr         QuotMSB


LOOP:
    adiw        QuotMSB:QuotLSB,1

    sub         FirstNumLSB,    Denominator
    sbci        FirstNumMSB,    0x00
    brcc        LOOP

    subi        QuotLSB,        0x01
    sbci        QuotMSB,        0x00

    adiw        FirstNumMSB:FirstNumLSB,  5

    ret



PRINT_DIODE:

    in          BtnValue,       PIND
    com         BtnValue

    cpi         BtnValue,       0b00000000
    breq        SNone

    cpi         BtnValue,       0b01000000
    breq        S10

    cpi         BtnValue,       0b00000100
    breq        S11

    cpi         BtnValue,       0b01000100
    breq        SBoth

    rjmp PRINT_DIODE

S10:
    out         PORTB,          QuotLSB
    rjmp        PRINT_DIODE

S11:
    out         PORTB,          QuotMSB
    rjmp        PRINT_DIODE

SBoth:
    out         PORTB,          FirstNumLSB
    rjmp PRINT_DIODE
SNone:
    ldi         R19,            0xFF
    out         PORTB,          R19

    rjmp PRINT_DIODE
