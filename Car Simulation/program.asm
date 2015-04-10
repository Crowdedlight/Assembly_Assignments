.include "m32def.inc"


.equ Set=0x55
.equ Get=0xAA
.equ Reply=0xBB

.equ Start=0x10
.equ Stop=0x11
.equ Register=0x12


ldi	R20, 0x00
ldi	R21, 0x0F
ldi	R22, 0xFF
ldi	R23, 0xBB
ldi	R24, 0x00		;LapCounter register
ldi	R25, 0x00		;Speed register 

;********************
;********************
;*  Initialisering  *
;********************
;********************

PORTA_Init:			;0 og 1 bruges til CNY70.
sbi	DDRA, 0
cbi	DDRA, 1

PORTD_Init:
sbi	DDRD, 2
cbi	PORTD, 2

PWM_Init:
sbi	DDRD, 7
ldi	R16, 0x00
out	OCR2, R16
ldi	R16, 0x6A
out	TCCR2, R16

USART_Init:
ldi	R16, 0b00000000		;UBRRH bruges til at sætte baudrate.
out 	UBRRH, R16
ldi	R16, 103		;UBRRL bruges til at sætte baudrate.
out 	UBRRL, R16

ldi 	R16, 0b00100000		;
out 	UCSRA, R16
				
ldi 	R16, 0b11111000		;
out 	UCSRB, R16

ldi 	r16, 0b10001110		;
out 	UCSRC, R16

Stack_init:
ldi	R16, HIGH(RAMEND)
out	SPH, R16
ldi	R16, LOW(RAMEND)
out	SPL, R16

;********************
;********************
;*       Main       *
;********************
;********************
Main:				;Main loop.
sbic 	UCSRA, RXC		;Tjek om der er modtaget seriel data.
call	USART_Receive

out	OCR2, R25		;Hastigheden sættes til værdien i R25

sbic	PINA, 1
call	LapCounter

jmp	Main			;Slutningen af mainloop.

;********************
;*    LapCounter    *
;********************
LapCounter:
sbic	PINA, 1
jmp 	LapCounter
inc	R24
ret

;********************
;*  USART Receiver  *
;********************
USART_Receive:
				;De 3 bytes gemmes i R29, R30 og R31.
USART_Receive1:

				;Wait for data to be received
sbis UCSRA, RXC
rjmp USART_Receive1

				; Get and return received data from buffer
in	R29, UDR

USART_Receive2:
sbis UCSRA, RXC
rjmp USART_Receive2

				; Get and return received data from buffer
in	R30, UDR

USART_Receive3:
sbis UCSRA, RXC
rjmp USART_Receive3

				; Get and return received data from buffer
in	R31, UDR


;********************
;*       Type	    *
;********************
cpi	R29, Set
breq	Type_Set

cpi	R29, Get
breq	Type_Get

cpi	R29, Reply
breq	Type_Reply

jmp	Error

;********************
;*   Set Command    *
;********************
Type_Set:
cpi	R30, Start
breq	Type_Set_Start

;cpi	R30, Stop
;breq	Type_Set_Stop

jmp	Error
;********************
;*   Get Command    *
;********************
Type_Get:
cpi	R30, Register
breq	Type_Get_Register

jmp	Error

;********************
;*    Set Start     *
;********************
Type_Set_Start:
mov 	R25, R31
ldi	R29, 0xBB
ldi	R30, 0x10 
jmp	USART_Transmit1


;********************
;*Get Register Data *
;********************
Type_Get_Register:
cpi	R31, 0x20
breq	Reply_Register_20

cpi	R31, 0x21
breq	Reply_Register_21

cpi	R31, 0x22
breq	Reply_Register_22

cpi	R31, 0x23
breq	Reply_Register_23

cpi	R31, 0x24
breq	Reply_Register_24

cpi	R31, 0x25
breq	Reply_Register_25

jmp	Error

;********************
;*  Reply Command   *
;********************
Type_Reply:

Error:
ldi	R29, 0xBB
ldi	R30, 0xBB
ldi	R31, 0xBB
jmp	USART_Transmit1
;####################
Reply_Register_20:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R20
rjmp	USART_Transmit1

Reply_Register_21:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R21
rjmp	USART_Transmit1

Reply_Register_22:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R22
rjmp	USART_Transmit1

Reply_Register_23:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R23
rjmp	USART_Transmit1

Reply_Register_24:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R24
rjmp	USART_Transmit1

Reply_Register_25:
ldi	R29, 0xBB
ldi	R30, 0x12
mov	R31, R25
rjmp	USART_Transmit1


;********************
;*  USART Transmit  *
;********************
USART_Transmit1:
				;Wait for empty transmit buffer
sbis 	UCSRA, UDRE
rjmp 	USART_Transmit1
				;Put data (R29) into buffer, sends the data
out	UDR, R29

USART_Transmit2:
sbis 	UCSRA, UDRE
rjmp 	USART_Transmit2
				;Put data (R30) into buffer, sends the data
out	UDR, R30

USART_Transmit3:
sbis 	UCSRA, UDRE
rjmp 	USART_Transmit3

				;Put data (R31) into buffer, sends the data
out	UDR, R31
ret
