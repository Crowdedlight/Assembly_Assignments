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

    ldi             R16,        HIGH(RAMEND)        ; Starting Stack
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
.def LastSwitch=R25                         ; Defining registers to names
.def Temp1=R16                              ; Setting Temp1, LastSwitch and TestDis (display)
.def Display=R20
.def COUNT=R26

.org 0xFF                                   ; Setting segment cycle in program memory for cycle display
segments: .db 0xBF,0xF7,0xFB,0xFD,0xFE,0xEF

    ldi     Temp1,          sega
    out     PORTB,          Temp1           ; Setting display to sega for startup


rjmp MAINLOOP                               ; Jump over RESET and start Mainloop

RESET:
    ldi     COUNT,      0x00                ; Resets counter in our loop to keep cycling
MAINLOOP:

    call    READSWITCH                      ; Call subroutine to readswitchs

    cpi     R17,    0x00                    ; Check if switchs are 0 then branch to
    breq    MAINLOOP                        ; stop the cycling

    call    DELAYLOOP                       ; subroutine to add the delay before next cycle

    call    CYCLEDISPLAY                    ; subroutine to show next segment

rjmp MAINLOOP

CYCLEDISPLAY:

    ldi     ZH,     high(segments<<1)       ; Getting high byte
    ldi     ZL,     low(segments<<1)        ; Getting low byte

    add     ZL,     COUNT                   ; Add count to byte to get correct segment
    ldi     Temp1,  0
    adc     ZH,     Temp1                   ; Handle carry

    lpm     Display,  Z                     ; load correct segment in cycle
    out     PORTB,  Display                 ; Display segment

    ldi     Temp1,  5                       ; Set 5 for testing purpose. (5 segments)
    cp      COUNT,  Temp1                   ; Compare to see if loop needs to reset
    breq    RESET                           ; Reset happens when reached final (5th) segment

    inc     COUNT                           ; Increment COUNT if last segment (5h) hasen't been reached
ret

DELAYLOOP:                                  ; Move Switch values into R29 to repeat 1ms delay decided
    mov     R29,    R17                     ; by switch values
DELAY1MS:                                   ; Start of the standard 1ms delay
    ldi     R30,    250                     ; 1 Clock cycle
LOOP:
    nop                                     ; 1 Clock cycle
    dec     R30                             ; 1 Clock cycle
    brne    LOOP                            ; If true 2 Clock cycles, If false 1 Clock cycle

    dec     R29                             ; 1 Clock cycle. Repeats the 1ms delay until the switch value
    brne    DELAY1MS                        ; reaches 0. 2 Clock cycles if true, 1 Clock cycle if false.

ret                                         ; If delay are done -> return to mainloop


READSWITCH:
    in      Temp1,    PINC                  ; Read in switch values

DELAYSTART:                                 ; Small delay for debouncing purpose
    ldi     R18,     150                    ; One clock cycle
DELAY3:
    dec     R18                             ; One clock cycle
    nop                                     ; One clock cycle
    brne    DELAY3                          ; Two clock cycles when jumping to Delay3, 1 clock when continuing to DEC

; Total delay = (4*150)+1 = 600 ~ 0,6ms

    in      R17,          PINC              ; Reads the secondary value for debouncing
    cp      Temp1,        R17               ; Compares first / second value
    brne    READSWITCH                      ; If not equal debounce = true => start over

    com     R17                             ; As switch is active low flip value for correct delay function
ret
