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


MAIN:

	in		R16,	PINC
	out		PORTB,	R16

rjmp MAIN
