; Note this program was written by Niall Hunt in 2016	
	AREA	Closure, CODE, READONLY
	IMPORT	main
	EXPORT	start

start

TRUE EQU 1
FALSE EQU 0
	
		LDR R0, =TRUE			; isClosed = true;
		LDR R1, =ASize
		LDR R1, [R1]			; ASize;
		LDR R2, =AElems			; R2 = ElemsAdr;
		LDR R3, =0				; Count = 0;
		LDR R6, =0				; runningtotal = 0;
		LDR R12, =0				; Cross out elements with 0
		
		
		CMP R1, #0				; if(ASize == 0)
		BEQ notnegated			;	isClosed = false;
								; 
								; 
		MOV R4, R2				; currElemAdr = ElemsAdr
totalstart						; while((count < ASize) && isClosed)	
		CMP R3, R1				; {	
		BHS endtotal			;	currElemA = memory.Word([currElemAdr]);
		LDR R5, [R4]			;	runningtotal += currElemA;
		ADD R6, R6, R5			;	count++;
		ADD R3, R3,#1			;	currElemAdr += 4;
		ADD R4, R4,#4			;	
		B totalstart			; 
endtotal						; }	
								;	
		CMP R6, #0				; if(runningtotal != 0)
		BNE notnegated			;	isClosed = false;
								;
		MOV R3, #0				; count1 = 0;
		MOV R4, R2				; currElemAdr = ElemsAdr;
		MOV R5, R4				; testElemAdr = (currElemAdr + 4);	
		ADD R5, R5,#4			; 	
		MOV R8, #1				; count2 = 1;
								; 
; Note this program was written by Niall Hunt in 2016
								
startunique						;	
		CMP R3, R1				; while(isClosed && count1 < ASize)
		BHS endunique			; {	
		CMP R0, #0				; 	
		BEQ endunique			; 
								;	
innerunique						;	while(isClosed && count2 < ASize)
		CMP R0, #0				;	{
		BEQ endinnerunique		;		
		CMP R8, R1				;		
		BHS endinnerunique		;		
								;		
		LDR R6, [R4]			;		currElem = memory.Word([currElemAdr]);
		LDR R7, [R5]			;		testElem = memory.Word([testElemAdr]);
								;	
		CMP R6, R7				;		if(currElem == testElem)
		BEQ equalvalues			;			isClosed = false;
								;	
		ADD R8, R8, #1			;		count2++;
		ADD R5, R5, #4			;		testElemAdr += 4;
		B innerunique			;		
								;	
equalvalues						;	
		MOV R0, #0				;	
		B endinnerunique		;	
								;	
endinnerunique					;	}
		ADD R4, R4, #4			;	currElemAdr += 4;
		MOV R5, R4				;	testElemAdr = (currElemAdr + 4);
		ADD R5, R5, #4			;	
		ADD R3, R3, #1			;	count1++;
		MOV R8, R3				;	count2 = (count1 + 1);
		ADD R8, R8,#1			;	
		B startunique			;	
								;	
endunique						; }	
								;	
		CMP R0, #TRUE			; 
		BNE notnegated			;	
								;	
		MOV R3, #0				; count1 = 0;	
		LDR R4, =AElems			; currElemAdr = startElemAdr;
								; 
outerwhile						; while(isClosed && count1 < ASize)
		CMP R0, #TRUE			; {	
		BNE endprogram			;	
		CMP R3, R1				;	
		BHS endprogram			;	
								;	
		MOV R0, #FALSE			;	isClosed = false;
		LDR R5, [R4]			;	currElem = memory.Word([currElemAdr]);
		MOV R6, R3				;	count2 = count1;
		MOV R7, R4				;	testElemAdr = (currElemAdr + 4);
		ADD R7, R7,#4			;	
								;	
innerwhile						;	while(!isClosed && count2 < ASize)
		CMP R0, #FALSE			;	{
		BNE endinnerwhile		;		
		CMP R6, R1				;	
		BHS endinnerwhile		;	
								;	
		LDR R8, [R7]			;		testElem = memory.Word([testElemAdr]);
		ADD R8, R8,R5			;		sum = currElem + testElem;
		CMP R8, #0				;		if(sum == 0)
		BNE notclosed			;		{
								;			
		MOV R0, #TRUE			;			isClosed = true;
		STR R12, [R4]			;			currElem = 0;                            //Crossing it out
		STR R12, [R7]			;			testElem = 0;                            //Crossing it out
		B endinnerwhile			;		}
								;		else
notclosed						;		{
		ADD R6, R6,#1			;			count2++;
		ADD R7, R7,#4			;			testElemAdr += 4;
		B innerwhile			;		}
								;	}
endinnerwhile					;	
								;	
		ADD R3, R3,#1			;	count1++;
		ADD R4, R4,#4			;	currElemAdr += 4;
		B outerwhile			; }
								;	
notnegated						;	
		MOV R0, #FALSE			;	
								;	
endprogram						;
stop	B	stop


	AREA	TestData, DATA, READWRITE

ASize	DCD	7			; Number of elements in A
AElems	DCD	0,-3,+9,-4,+3,-9,+4	; Elements of A

	END
; Note this program was written by Niall Hunt in 2016
