	AREA	ConsoleInput, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start

	LDR R4, =0				; Running total in R5
	LDR R5, =10				; Store 10 to use in the multiplication of total
	
read
	BL	getkey				; read key from console
	CMP	R0, #0x0D			; while(ch != CR)
	BEQ	endRead				; {
	CMP R0, #0x30			; 		if((ch >= '0') && (ch <= '9'))
	BLO read				;		{
	CMP R0, #0x39			;		
	BHI read				;		 	 	
	BL	sendchar			;   		echo key back to console
	
	SUB R0, R0, #0x30 		; 			value = ch - 0x30
	MUL R4, R5, R4			;			total = total * 10
	ADD R4, R4, R0			; 			total = total + value

	B	read				; 		}
							; }
endRead
stop	B	stop

	END	
