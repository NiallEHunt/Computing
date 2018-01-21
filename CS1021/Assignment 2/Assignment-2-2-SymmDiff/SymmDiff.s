	AREA	SymmDiff, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
		LDR R0, =ASize		
		LDR R0, [R0]			; ASize = memory.Word([ASizeAdr]);
		LDR R1, =0				; countA = 0;
		LDR R2, =AElems			; AElemsAdr;
		LDR R3, =0				; currElemA = 0;
		LDR R4, =BSize			
		LDR R4, [R4]			; BSize = memory.Word([BSizeAdr]);
		LDR R5, =0				; countB = 0;
		LDR R6, =BElems			; BElemsAdr;
		LDR R7, =0				; currElemB = 0;
		LDR R8, =CSize		
		LDR R9, =0				; countC =0;
		LDR R10, =CElems		; CElemsAdr;
		
outerwhilea						; while(countA < ASize)
		CMP R1, R0				; {	
		BHS endouterwha			; 	
								; 	isStored = true;
		LDR R3, [R2]			; 	currElemA = memory.Word([AElemsAdr]);
		ADD R2, R2,#4			; 	AElemsAdr += 4;
								; 	
innerwhilea						; 	while((countB <= BSize) && isStored)
		CMP R5, R4				; 	{
		BHI endinnerwha			; 		
								; 		
		LDR R7, [R6]			; 		currElemB = memory.Word([BElemsAdr]);
		ADD R6, R6,#4			; 		BElemsAdr += 4;
		CMP R5, R4				; 		if(countB == BSize)
		BNE elseifa				; 		{
		STR R3, [R10]			; 			memory.Store(currElemA, [CElemsAdr]);
		ADD R10, R10,#4			; 			CElemsAdr += 4;
		ADD R9, R9,#1			; 			countC++;
		B endinnerwha			; 		}
elseifa							; 		else if(currElemB == currElemA)
		CMP R7, R3				; 		{
		BEQ endinnerwha			; 			isStored = false
								; 		}
		ADD R5, R5,#1			; 		else	
		B innerwhilea			; 		{
								; 			countB++;
endinnerwha						; 		}
								;	} 		
		ADD R1, R1,#1			; 	countA++;	
		MOV R5, #0				; 	countB = 0;
		LDR R6, =BElems			;   BElemsAdr = BElemsStartAdr;
		B outerwhilea			; }	
								; 
endouterwha						; 
								; 
		LDR R0, =ASize			; 	
		LDR R0, [R0]			; ASize = memory.Byte([ASizeAdr]);
		LDR R1, =0				; countA = 0;
		LDR R2, =AElems			; AElemsStartAdr;
		LDR R3, =0				; currElemA = 0;
								; 
outerwhileb						; while(countB <= BSize)
		CMP R5, R4				; {
		BHI endouterwhb			; 	isStored = true;
								;	
		LDR R7, [R6]			; 	currElemB = memory.Word([BElemsAdr]);
		ADD R6, R6,#4			; 	BElemsAdr += 4;
		CMP R5, R4				;	if(countB == BSize)	 
		BNE innerwhileb			; 	{
		STR R9, [R8]			;  		CSize = countC;
		B endouterwhb			; 	}
								; 	else
innerwhileb						; 	{
		CMP R1, R0				; 		while((countA <= ASize) && isStored)
		BHI endinnerwhb			; 		{
								; 			
		LDR R3, [R2]			; 			currElemA = memory.Word([AElemsAdr]);
		ADD R2, R2,#4			; 			AElemsAdr += 4;
		CMP R1, R0				; 			if(countA == ASize)
		BNE elseifb				; 			{
		STR R7, [R10]			; 				memory.Store(currElemB, [CElemsAdr]);
		ADD R10, R10,#4			; 				CElemsAdr += 4;
		ADD R9, R9,#1			; 				countC++;
		B endinnerwhb			; 			}
elseifb							; 			else if(currElemB == currElemA)
		CMP R7, R3				; 			{
		BEQ endinnerwhb			; 				isStored = false;
								; 			}
		ADD R1, R1,#1			; 			else
		B innerwhileb			; 			{
								; 				countA++;
endinnerwhb						; 			}
								; 		}
		ADD R5, R5,#1			; 		countB++;	
		MOV R1, #0				; 		countA = 0;
		LDR R2, =AElems			; 		AElemsAdr = AElemsStartAdr;
		B outerwhileb			; 	}
								; }
endouterwhb						; 
		
		; Loop to test each element stored in C
		; Uncomment to use
		; Run through step by step in debugger
		; CElems stored in R10
		
		;MOV R9, #0
		;LDR R11, [R8]
		;LDR R12, =CElems
;loop
		;CMP R9, R11			
		;BHS endloop
		;LDR R10, [R12]
		;ADD R12, R12,#4
		;ADD R9, R9,#1
		;B loop
;endloop

stop	B	stop


	AREA	TestData, DATA, READWRITE

ASize	DCD	8			; Number of elements in A
AElems	DCD	4,6,2,13,19,7,1,3	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD	13,9,1,20,5,8		; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE	56			; Elements of C

	END
