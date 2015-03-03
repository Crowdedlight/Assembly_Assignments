.include "m32def.inc"

;Initialisér programmet

RESET:

    ; PORTC setup

    ldi				R16,		0x00				; Read input into R16
    out				DDRC,		R16					; Set PORTC as input
    ldi				R16,		255					; Set Pull-up value in R16 (Max value in decimal)
    out 			PORTC,   	R16 				; Enable pull-up on PORTC

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
.equ seg9=0b10000011

    ldi     R20,    1       ; Start counter at 1 as we start showing 0 then 1 sec delay then program runs
    ldi     R16,    seg0    ; Setting value for 0 for next operation
    out     PORTB,  R16     ; Setting display to 0 for startup

DELAYSTART:

DELAY_1sec:                 ; For CLK(CPU) = 1 MHz
    ldi     R16,    8       ; One clock cycle
DELAY1:
    ldi     R17,    125     ; One clock cycle
DELAY2:
    ldi     R18,    250     ; One clock cycle

DELAY3:
    dec     R18             ; One clock cycle
    nop                     ; One clock cycle
    brne    DELAY3          ; Two clock cycles when jumping to Delay3, 1 clock when continuing to DEC

    dec     R17             ; One clock cycle
    brne    DELAY2          ; Two clock cycles when jumping to Delay2, 1 clock when continuing to DEC

    dec     R16             ; One clock cycle
    brne    DELAY1          ; Two clock cycles when jumping to Delay1, 1 clock when continuing to DEC

; Total delay = (4*250)*125+(125*3) = 125.375
; 125.375*8+(8*5)+3 = 1.003.067 ≃ 1.000.000 Clock cycles

TESTER:

    cpi     R20,    0       ;Compare to get counters position
    breq    NUM0            ;Jump to NUM0 if counter at position 0

    cpi     R20,    1
    breq    NUM1

    cpi     R20,    2
    breq    NUM2

    cpi     R20,    3
    breq    NUM3

    cpi     R20,    4
    breq    NUM4

    cpi     R20,    5
    breq    NUM5

    cpi     R20,    6
    breq    NUM6

    cpi     R20,    7
    breq    NUM7

    cpi     R20,    8
    breq    NUM8

    cpi     R20,    9
    breq    NUM9


NUM0:
    inc     R20             ; Incrementing counter
    ldi     R16,    seg0    ; Set output in register
    out     PORTB,  R16     ; Send output to display
rjmp    DELAYSTART          ; Jump back to delay to have 1sec delay until next number

NUM1:
    inc     R20
    ldi     R16,    seg1
    out     PORTB,  R16
rjmp    DELAYSTART

NUM2:
    inc     R20
    ldi     R16,    seg2
    out     PORTB,  R16
rjmp    DELAYSTART

NUM3:
    inc     R20
    ldi     R16,    seg3
    out     PORTB,  R16
rjmp    DELAYSTART

NUM4:
    inc     R20
    ldi     R16,    seg4
    out     PORTB,  R16
rjmp    DELAYSTART

NUM5:
    inc     R20
    ldi     R16,    seg5
    out     PORTB,  R16
rjmp    DELAYSTART

NUM6:
    inc     R20
    ldi     R16,    seg6
    out     PORTB,  R16
rjmp    DELAYSTART

NUM7:
    inc     R20
    ldi     R16,    seg7
    out     PORTB,  R16
rjmp    DELAYSTART

NUM8:
    inc     R20
    ldi     R16,    seg8
    out     PORTB,  R16
rjmp    DELAYSTART

NUM9:
    ldi     R20,    0
    ldi     R16,    seg9
    out     PORTB,  R16
rjmp    DELAYSTART
