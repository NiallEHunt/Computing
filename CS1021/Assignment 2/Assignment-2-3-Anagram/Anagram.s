; Note this program was written by Niall Hunt in 2016
	
	AREA	Anagram, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
TRUE EQU 1
FALSE EQU 0
		
		LDR R0, =FALSE				; isAnagram = false;
		LDR	R1, =stringA			; stringAAdr = startStringA;
		LDR	R2, =stringB			; stringBAdr = startStringB;
		LDR R3, =0					; numberOfCharA = 0;
		LDR R4, =0					; numberOfCharB = 0;
		
acount								; while(memory.Byte[stringAAdr] != NUL)
		LDRB R5, [R1]				; {
		ADD R1, R1,#1				; 	stringAAdr++;
		CMP R5, #0x0				;	numberofCharA++;
		BEQ bcount					; }
		CMP R5, #'A'
		BLO acount
		CMP R5, #'z'
		BHI acount
		CMP R5, #'Z'
		BLO isletter
		CMP R5, #'a'
		BLO acount
isletter		
		ADD R3, R3,#1				;
		B acount					;
bcount								; while(memory.Byte[stringBAdr] != NUL)
		LDRB R5, [R2]				; {
		ADD R2, R2,#1				; 	stringBAdr++;
		CMP R5, #0x0				; 	if((char >= 'A' && char <= 'Z')	|| (char >= 'a' && char <= 'z'))
		BEQ endbcount				; 	{
		ADD R4, R4,#1				; 		numberofCharB++;
		B bcount					; 	}
endbcount							; 
									; 
		CMP R3, R4					; if(numberOfCharA == numberOfCarB)
		BNE endprogram				; {
									; 	
		LDR R1, =stringA			; 	stringAAdr = startStringA;
									; 	
outerwhile							; 	while(memory.Byte[stringAAdr] != NUL)
		LDR R2, =stringB			; 	{
		LDRB R3, [R1]				; 		stringBAdr = startStringB;
		ADD R1, R1,#1				; 		currAChar = memory.Byte[stringAAdr];
									;		stringAAdr++;
		CMP R3, #0x0				; 		if((currAChar >= 'A') && (currAChar <= 'Z'))
		BEQ endprogram				; 		{
		CMP R3, #0x1				; 			currAChar += 0x20;
		BEQ outerwhile				; 		}
		CMP R3, #'A'				; 		if(currAChar >= 'a' && currAChar <= 'z')
		BLO anotcapital				; 		{
		CMP R3, #'Z'				; 			
		BHI anotcapital				; 			
		ADD R3, R3,#0x20			; 				
anotcapital							; 				
		CMP R3, #'a'				; 				
		BLO outerwhile				;				
		CMP R3, #'z'				; 				
		BHI outerwhile				; 				
									; 			while(memory.Byte[stringBAdr] != NUL)	
innerwhile 							; 			{
		LDRB R4, [R2]				; 				currBChar = memory.Byte[stringBAdr];	
		ADD R2, R2,#1				; 				stringBAdr++;
		CMP R4, #0x0				; 				if((currAChar >= 'A') && (currAChar <= 'Z'))
		BEQ nullchar				; 				{
		CMP R4, #0x1				; 					currAChar += 0x20;
		BEQ innerwhile				; 				}
		CMP R4, #'A'				; 				if(currAChar >= 'a' && currAChar <= 'z')
		BLO bnotcapital				; 				{
		CMP R4, #'Z'				; 					
		BHI bnotcapital				; 					
		ADD R4, R4,#0x20			; 					
bnotcapital							; 					
		CMP R4, #'a'				; 					
		BLO innerwhile				; 					
		CMP R4, #'z'				; 					
		BHI innerwhile				; 
									; 
; Note this program was written by Niall Hunt in 2016
									
									; 
		CMP R3, R4					; 					if(currAChar == currBChar)
		BNE innerwhile				; 					{
		MOV R0, #TRUE				; 						isAnagram = true;
		MOV R3, #0x1				; 						currAChar = #0x1;
		MOV R4, #0x1				; 						currBChar = #0x1;
		B outerwhile				; 					}	
									; 					else if(currBChar == NUL)
nullchar							; 					{
		MOV R0, #FALSE				; 						isAnagram = false;
									; 					}
									;				}
									;
									;			}
									;		}
									;	}
endprogram							; }				
stop	B	stop



	AREA	TestData, DATA, READWRITE

stringA	DCB	"Tom's",0
stringB	DCB	"Most",0

	END
; Note this program was written by Niall Hunt in 2016
