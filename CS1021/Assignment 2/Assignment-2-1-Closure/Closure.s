	AREA	Closure, CODE, READONLY
	IMPORT	main
	EXPORT	start

start

TRUE EQU 1
FALSE EQU 0
		LDR R0, =TRUE			; isClosed = true;
		;LDR R1, #
	

stop	B	stop


	AREA	TestData, DATA, READWRITE

ASize	DCD	8			; Number of elements in A
AElems	DCD	+4,-6,-4,+3,-8,+6,+8,-3	; Elements of A

	END
