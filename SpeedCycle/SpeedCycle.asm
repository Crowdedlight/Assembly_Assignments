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

    ; Stack Init

    ldi             R16,        HIGH(RAMEND)
    out             SPH,        R16
    ldi             R16,        LOW(RAMEND)
    out             SPL,        R16


; Setting Variables

.equ sega=0b10111111
.equ segb=0b11110111
.equ segc=0b11111011
.equ segd=0b11111101
.equ sege=0b11111110
.equ segf=0b11101111
.def LastSwitch=R25     ; Defining registers to names
.def Temp1=R16          ; Setting Temp1, LastSwitch and TestDis (display)
.def Display=R20
.def COUNT=R26

.org 0xFF
segments: .db 0xBF,0xF7,0xFB,0xFD,0xFE,0xEF

    ldi     Temp1,          sega
    out     PORTB,          Temp1     ; Setting display to sega for startup


rjmp MAINLOOP

RESET:
    ldi     COUNT,      0x00

MAINLOOP:

    call    READSWITCH

    cpi     R17,    0x00
    breq    MAINLOOP

    call    DELAYLOOP

    call    CYCLEDISPLAY

rjmp MAINLOOP

CYCLEDISPLAY:

    ldi     ZH,     high(segments<<1)
    ldi     ZL,     low(segments<<1)

    add     ZL,     COUNT
    ldi     Temp1,  0
    adc     ZH,     Temp1

    lpm     Display,  Z
    out     PORTB,  Display

    ldi     Temp1,  5
    cp      COUNT,  Temp1
    breq    RESET

    inc     COUNT
ret

DELAYLOOP:
    mov     R29,    R17
DELAY1MS:
    ldi     R30,    250
LOOP:
    nop
    dec     R30
    brne    LOOP

    dec     R29
    brne    DELAY1MS

ret


READSWITCH:
    in      Temp1,    PINC

DELAYSTART:
    ldi     R18,     150    ; One clock cycle
DELAY3:
    dec     R18             ; One clock cycle
    nop                     ; One clock cycle
    brne    DELAY3          ; Two clock cycles when jumping to Delay3, 1 clock when continuing to DEC

; Total delay = (4*250) = 1000 = 1ms

    in      R17,          PINC      ; Reads the secondary value for debouncing
    cp      Temp1,        R17       ; Compares first / second value
    brne    READSWITCH              ; If not equal debounce = true => start over

    com     R17
ret
