.include "m32def.inc"

;SETUP

RESET:

    ; PORTC setup

    ldi				R16,		0x00				; Read input into R16
    out				DDRC,		R16					; Set PORTC as input
    ldi				R16,		255					; Set Pull-up value in R16 (Max value in decimal)
    out 			PORTC,   	R16 				; Enable pull-up on PORTC

    ; PORTB setup

    ldi				R16,		0xFF				; Set output value in R16
    out			 	DDRB,		R16 				; PORTB = output


; Setting Variables

.equ sega=0b10111111
.equ segb=0b11110111
.equ segc=0b11111011
.equ segd=0b11111101
.equ sege=0b11111110
.equ segf=0b11101111
.def LastSwitch=R25     ; Defining registers to names
.def Temp1=R16          ; Setting Temp1, LastSwitch and TestDis (display)
.def TestDis=R20


    ldi     Temp1,      0xFF      ; Setting value for empty display
    out     PORTB,      TEMP1     ; Setting display to 0 for startup
    nop
    in      LastSwitch, PINC      ; Setting start value of switchs

READSWITCH:
    in      Temp1,    PINC

DELAYSTART:
    ldi     R18,    250     ; One clock cycle
DELAY3:
    dec     R18             ; One clock cycle
    nop                     ; One clock cycle
    nop                     ; One clock cycle
    nop                     ; One clock cycle
    nop                     ; One clock cycle
    nop                     ; One clock cycle
    brne    DELAY3          ; Two clock cycles when jumping to Delay3, 1 clock when continuing to DEC

; Total delay = (8*250) = 1000 = 1ms

    in      R17,          PINC      ; Reads the secondary value for debouncing
    cp      Temp1,        R17       ; Compares first / second value
    brne    READSWITCH              ; If not equal debounce = true => start over

    cp      Temp1,        LastSwitch    ; Compare last known value of switch with new
    breq    READSWITCH                  ; If equal start over

    mov     LastSwitch,   Temp1         ; Saves new Last known value of switch

TESTERDISPLAY:

    in      TestDis,    PINB    ; Read value of 7-seg display

    cpi     TestDis,    0xFF    ; Compare to get counters position
    breq    A                   ; Jump to A if display == empty

    cpi     TestDis,    sega    ; Compare to get counters position
    breq    B                   ; Jump to B if display == A

    cpi     TestDis,    segb    ; Compare to get counters position
    breq    C                   ; Jump to C if display == B

    cpi     TestDis,    segc    ; Compare to get counters position
    breq    D                   ; Jump to D if display == C

    cpi     TestDis,    segd    ; Compare to get counters position
    breq    E                   ; Jump to E if display == D

    cpi     TestDis,    sege    ; Compare to get counters position
    breq    F                   ; Jump to F if display == E

    cpi     TestDis,    segf    ; Compare to get counters position
    breq    A                   ; Jump to A if display == F

A:
    ldi     Temp1,  sega        ; Writes sega value for output
    out     PORTB,  Temp1       ; Sends value to display
rjmp    READSWITCH              ; Jumps back to check switches

B:
    ldi     Temp1,  segb        ; Same as A just for B and so on ...
    out     PORTB,  Temp1
rjmp    READSWITCH

C:
    ldi     Temp1,  segc
    out     PORTB,  Temp1
rjmp    READSWITCH

D:
    ldi     Temp1,  segd
    out     PORTB,  Temp1
rjmp    READSWITCH

E:
    ldi     Temp1,  sege
    out     PORTB,  Temp1
rjmp    READSWITCH

F:
    ldi     Temp1,  segf
    out     PORTB,  Temp1
rjmp    READSWITCH
