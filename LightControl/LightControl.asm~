.include "m32def.inc"

;SETUP

SETUP:

    ; PORTA setup

    ldi				R16,		0x00				; Set output value in R16
    out			 	DDRA,		R16 				; PORTB = output

    ; Potentiometer setup

    ldi             R16,        0b11100011          ; Prescale CK/8 (byte = 3)
    out             ADCSR,      R16

    ; Under 200 KHz = 1MHz / 8 = 125 KHz

    ; ARef as Reference

    ldi             R16,        0b00100000          ; select the onboard potentiometer
    out             ADMUX,      R16                 ; Extern 5V ref with left-adjusted

    ; PORTB setup

    sbi             DDRB,       3                   ; Setting up display for single segment


MAIN:


; Fast, inverted PWM
    ldi             R18,        0b01111001          ; Fast, Inverted PWM with prescale 1
    out             TCCR0,      R18

; PWM Frequency 4Kz = 1MHz/(4KHz*256) = 1

WAIT:
    sbis            ADCSR,      ADIF                ; Skip if flag is set. Built in delay for readings
    rjmp            WAIT

    sbi             ADCSR,      ADIF                ; Set flag to 0 by sending 1 to it...
    in              R16,        ADCL                ; Read low first. Because you have to...
    in              R16,        ADCH                ; Read high which is used

    out             OCR0,       R16                 ; Send to Timer Out

    rjmp            WAIT                            ; Repeat Loop



; Send to diode
