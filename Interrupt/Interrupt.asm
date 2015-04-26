.include "m32def.inc"

.org 0
    jmp Reset

.org 0x14
    jmp SetDisplay

.org 0x30

; SETUP
Reset:
    ; PORTB setup
    ldi     R16,        0b01100010
    out     DDRB,       R16                 ; Setting up display for single segment

    ldi     R16,        0xFF
    out     PORTB,      R16

; Init Stack

    ldi     R16,        HIGH(RAMEND)        ; Starting Stack
    out     SPH,        R16
    ldi     R16,        LOW(RAMEND)
    out     SPL,        R16

; Setup Interrupt
    sei
    ldi     R16,        2                   ; OCIE0 set high
    out     TIMSK,      R16

; Timer0 - CTC mode, 10 ticks
    ldi     R16,        9                   ;
    out     OCR0,       R16                 ;

    ldi     R16,        0b00001101          ; No Prescale
    out     TCCR0,      R16                 ;

; Variabler

.equ SegTop=0b01000000
.equ SegMid=0b00100000
.equ SegBot=0b00000010


Main:

    rjmp    Main                            ; Repeat Loop

SetDisplay:
    in      R16,        TIFR
    out     TIFR,       R16                   ; Clear interrupt bit


TOP_Compare:
    inc     R20
    cpi     R20,        25
    breq    TOP_Toggle

MID_Compare:
    inc     R21
    cpi     R21,        50
    breq    MID_Toggle

BOT_Compare:
    inc     R22
    cpi     R22,        75
    breq    BOT_Toggle

    reti

TOP_Toggle:
    clr     R20
    in      R18,        PINB
    ldi     R26,        SegTop
    eor     R18,        R26

    out     PORTB,      R18
    rjmp    MID_Compare

MID_Toggle:
    clr     R21
    in      R18,        PINB
    ldi     R26,        SegMid
    eor     R18,        R26

    out     PORTB,      R18
    rjmp    BOT_Compare

BOT_Toggle:
    clr     R22
    in      R18,        PINB
    ldi     R26,        SegBot
    eor     R18,        R26

    out     PORTB,      R18

    reti
