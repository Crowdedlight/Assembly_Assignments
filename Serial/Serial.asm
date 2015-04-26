.include "m32def.inc"

.org 0
    rjmp Main

.org UDREaddr
    rjmp ISR_UDRE

.org URXCaddr
    rjmp ISR_URXC

.org 0x2A                                   ; Skipping interrupt vektor tabel

; SETUP
Reset:

; Init Stack

    ldi     R16,        HIGH(RAMEND)        ; Starting Stack
    out     SPH,        R16
    ldi     R16,        LOW(RAMEND)
    out     SPL,        R16

; Setup Serial

; Setting serial ON
    ldi     R16,        (1<<RXEN)|(1<<TXEN)
    out     UCSRB,      R16

; Using UCSRC, Framesize = 8
    ldi     R16,        (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0)
    out     UCSRC,      R16

;Setting baud rate = 9600 (UBRR = 6 = 0x06)
    ldi     R16,        0x06                ; UBRR LSB
    out     UBRRL,      R16

    SEI                                     ; Interrupt enabled

Main:
    ; Do nothing but wait for interrupts
rjmp Main

ISR_UDRE:                                   ; ISR
    ldi     R16,        'A'                 ; Write data to send
    out     UDR,        R16                 ; Send Data

    reti


ISR_URXC:                                   ; ISR
    in      R16,        UDR                 ; Recieve Data

    ; DO SOMETHING

    reti
