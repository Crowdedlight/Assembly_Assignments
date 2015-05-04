.include "m32def.inc"

.org 0
    rjmp Reset

.org URXCaddr                               ; Interrupt for recieve data
    rjmp Recieve

.org 0x2A                                   ; Skipping interrupt vektor tabel

; SETUP
Reset:

; Init Stack

    ldi     R16,        HIGH(RAMEND)        ; Starting Stack
    out     SPH,        R16
    ldi     R16,        LOW(RAMEND)
    out     SPL,        R16

; Setup Serial

; Setting serial ON And Recieve Interrupt
    ldi     R16,        (1<<RXEN)|(1<<RXCIE)|(1<<TXEN)
    out     UCSRB,      R16

; Using UCSRC, Framesize = 8
    ldi     R16,        (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0)
    out     UCSRC,      R16

; UCSRA
    ldi     R16,        (1<<U2X)            ; Less error by enabling U2X and UBRR = 12
    out     UCSRA,      R16

;Setting baud rate = 9600 (UBRR = 12)
    ldi     R16,        12                  ; UBRR LSB
    out     UBRRL,      R16

    SEI                                     ; Interrupt enabled

Main:
    ; Do nothing but wait for interrupts
rjmp Main



Recieve:
    in      R16,        UDR                 ; Recieve Data
    cpi     R16,        65                  ; Compare ascii value to 65
    brlt    Send                            ; Branch if less than 65
    cpi     R16,        123                 ; Compare ascii value to 123
    brge    Send                            ; Branch if greater or equal to 123
    cpi     R16,        91                  ; If value is < 91 but still >= 65
    brlt    UpperCase                       ; It's a Capital letter
    cpi     R16,        97                  ; If value < 97 but also >= 91 it's
    brlt    Send                            ; Symbols and shall just be send
    cpi     R16,        123                 ; If value < 123 but still >= 97
    brlt    LowerCase                       ; It's lowercase letter

    reti

LowerCase:
    ldi     R18,        32                  ; Add 32 as the difference from capital letter to
    sub     R16,        R18                 ; same lowercase letter is 32. Subtract 32 to make
                                            ; Capital letters and then send them
    rjmp    Send

Uppercase:
    ldi     R18,        32                  ; Adding 32 instead, to make lowercase letters
    add     R16,        R18

    rjmp    Send


Send:                                       ; Send Data
    sbis    UCSRA,      UDRE                ; Skip if ready to send data - Polling
    rjmp    Send


    out     UDR,        R16                 ; Send Data

    reti
