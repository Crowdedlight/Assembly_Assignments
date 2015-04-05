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

; Clearing Register
    clr         QuotMSB
    clr         QuotLSB
    clr         BtnValue
    clr         Denominator
    clr         SecondNumLSB
    clr         SecondNumMSB

MAIN:

    ldi         NumLSB,    Low(2655)                ; Load first num
    ldi         NumMSB,    High(2655)               ; LSB and MSB

    ldi         SecondNumLSB,   Low(74)             ; Load second Num
    ldi         SecondNumMSB,   High(74)            ; LSB and MSB

    call        SUM16                               ; Call Sum function to add

    ldi         SecondNumLSB,   Low(592)            ; load next num
    ldi         SecondNumMSB,   High(592)           ; LSB and MSB

    call        SUM16                               ; and so on

    ldi         SecondNumLSB,   Low(1380)
    ldi         SecondNumMSB,   High(1380)

    call        SUM16

    ldi         SecondNumLSB,   Low(17352)
    ldi         SecondNumMSB,   High(17352)

    call        SUM16

    ldi         Denominator,    5                   ; Set denominator to 5
    call        DIV16_8                             ; Call division function

    com         NumLSB                              ; Complement for showing
    com         NumMSB                              ; As it's active low
    com         Denominator

    rjmp PRINT_DIODE                                ; Jump to Print_Diode loop

SUM16:

    add         NumLSB,    SecondNumLSB             ; Add LSB together
    adc         NumMSB,    SecondNumMSB             ; Add with carry MSB

    ret


DIV16_8:
    adiw        QuotMSB:QuotLSB, 1                  ; Increment counter

    sub         NumLSB,    Denominator              ; Sub 5 from number LSB
    sbci        NumMSB,    0                        ; Sub 0 with carry MSB
    brcc        DIV16_8                             ; Break if NumMSB >=0

    subi        QuotLSB,        1                   ; One to many subs
    sbci        QuotMSB,        0                   ; sub 1 from quot

    adiw        NumMSB:NumLSB,  5                   ; add the last 5 back to number

    mov         Denominator,    NumLSB              ; Move to correct register for assignement
    movw        NumMSB:NumLSB,  QuotMSB:QuotLSB     ; Move word to register as assignment said

    ret


PRINT_DIODE:

    sbis        PIND,           6                   ; Skip next if S10 isn't activated
    rjmp        S10                                 ; Jump to S10

    sbis        PIND,           2                   ; Skip next if S11 isn't activated
    rjmp        S11                                 ; Jump to S11


SNone:
    ldi         R19,            0xFF                ; If no buttons pressed load 250
    out         PORTB,          R19                 ; Shuts off display

    rjmp PRINT_DIODE

S10:
    sbis        PIND,           2                   ; Skip next if S11 isn't pressed as well
    rjmp        SBoth                               ; Jump as both is pressed

    out         PORTB,          NumLSB              ; Otherwise show NumLSB
    rjmp        PRINT_DIODE

S11:
    sbis        PIND,           6                   ; Skip next if S10 isn't pressed as well
    rjmp        SBoth                               ; Jump as both is pressed

    out         PORTB,          NumMSB              ; Otherwise show NumMSB
    rjmp        PRINT_DIODE

SBoth:
    out         PORTB,          Denominator         ; If boths pressed show Rest
    rjmp PRINT_DIODE
