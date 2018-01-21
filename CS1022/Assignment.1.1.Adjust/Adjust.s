; Note this program was written by Niall Hunt in 2016
	
	AREA	Adjust, CODE, READONLY
	IMPORT	main
	IMPORT	getPicAddr
	IMPORT	putPic
	IMPORT	getPicWidth
	IMPORT	getPicHeight
	EXPORT	start

	PRESERVE8
	
start

	BL	getPicAddr				; load the start address of the image in R4

	MOV R1, #32		; Alpha
	MOV R2, #0				; Beta
	
	BL brightenAndContrast		; brightenAndContrast(PicStartAdr, Alpha, Beta);

	BL	putPic					; re-display the updated image


stop	B	stop




; Name: 		brightenAndContrast
; Parameters:   R0 = picStartAdr
;			    R1 = Alpha
;			    R2 = Beta
; Function: 	Loops through every pixel of the picture brightening them or increasing
;				the contrast based on the Alpha and Beta values. The function uses the 
;				the following equation to do these operations: 
;				((R/G/B value * Alpha) ÷ 16) + Beta
; Returns:		void
; Note this program was written by Niall Hunt in 2016

brightenAndContrast
	STMFD sp!, {R4-R10, LR}		; push(R4-R10, LR);
	
	STMFD sp!, {R0-R2}			; push(R0-R2);
	BL getPicHeight				; R6(picHeight) = getPicHeight();	
	MOV R6, R0					; 
	BL getPicWidth				; R5(picWidth) = getPicWidth();
	MOV R5, R0					;
	LDMFD sp!, {R0-R2}			; pop(R0-R2);
								;
	MOV R3, #0					; for(int j = 0;(j < picHeight);j++)
JFor							; {
	CMP R3, R6					; 	for(int i = 0;(i < picWidth);i++)
	BGE endJFor					;	{
								;		
	MOV R4, #0					;		
IFor							;		
	CMP R4, R5					;		
	BGE endIFor					;		
								;		
	MUL R7, R3, R5				;		R7(offset) = j * picWidth;
	ADD R7, R7, R4				;		offset += i;
	LSL R7, R7, #2				;		offset *= 4;
								;		
	MOV R8, #0					;		
calFor							;		for(int count = 0;(count < 3);count++)
	CMP R8, #3					;		{
	BGE endCalFor				;			
								;			
	LDRB R9, [R0, R7]			;			R9(R/G/BValue) = memory.LoadByte(picStartAdr + offset);
								;			
	STMFD sp!, {R0-R3}			;			push(R0-R3);
	MOV R0, R9					;			
	BL brightenAndContrastCal	;			brightenAndContrastCal(R/G/BValue);
	MOV R9, R0					;			
	LDMFD sp!, {R0-R3}			;			pop(R0-R3);
								;			
	STRB R9, [R0, R7]			;			memory.StoreByte(R/G/BValue);
								;			
	ADD R7, R7, #1				;			offset++;
	ADD R8, R8, #1				;			
	B calFor					;		}	
endCalFor						;			
								;			
	ADD R4, R4, #1				;	
	B IFor						;	}
endIFor							;
								;
	ADD R3, R3, #1				;
	B JFor						; }
endJFor							;
	LDMFD sp!, {R4-R10, PC}		; pop(R4-R10, PC);
								;
; Note this program was written by Niall Hunt in 2016



; Name:			division
; Parameters: 	R0 = number to be divided
;			 	R1 = divisor
; Function: 	Performs integer division with two numbers, resulting in a quotient and remaider.
; Returns: 		R0 = remainder
;		  		R2 = quotient
division
	STMFD sp!, {LR}			; push(LR);
	CMP R1, #0				; if(divisor != 0)
	BEQ quotientIsZero		; {
	MOV R2, #0				; 	quotient = 0;
divLoop						; 	while(numberToBeDivided >= divisor)
	CMP R0, R1				; 	{
	BLO endDivLoop			; 		
	SUB R0, R0, R1			; 		numberToBeDivided -= divisor;
	ADD R2, R2, #1			; 		quotient++;
	B divLoop				; 		
							; 	}
quotientIsZero				; } 	
	MOV R2, #0				; else	
							; 	quotient = 0;
endDivLoop					; return quotient;
	LDMFD sp!, {PC}			; pop(PC);
	
	
	
	
; Name:			brightenAndContrastCal
; Parameters:	R0 = R/G/B value
;				R1 = Alpha
;				R2 = Beta
; Function:		Takes in a R/B/G value and performs the calculation: ((R/G/B value * Alpha) ÷ 16) + Beta
;				This is the formula to brighten and contrast the image based on the alpha and beta values.
;				This is capped at 255 and is not allowed to go below 0
; Returns:		R0 = Updated R/G/B value
brightenAndContrastCal
	
	STMFD sp!, {LR}				; push(LR);
	CMP R1, #16					; if(alpha != 16)
	BEQ addBeta					; {
								;	
	MUL R0, R1, R0				;	R/G/BValue *= alpha;
	STMFD sp!, {R1-R3}			;	push(R1-R3);
	MOV R1, #16					;	
	BL division					;	divide(R/G/BValue, 16);
	MOV R0, R2					;	
	LDMFD sp!, {R1-R3}			;	pop(R1-R3);
addBeta							; }
	ADD R0, R0, R2				; R/G/BValue += beta;
								;
	CMP R0, #255				; if(R/G/BValue > 255)
	BGT greater 				;	R/G/BValue = 255;
	CMP R0, #0					; else if(R/G/BValue < 0)
	BGE endif					; 	R/G/BValue = 0;
	MOV R0, #0					;
	B endif						;
greater							;
	MOV R0, #255				;
endif							;
	LDMFD sp!, {PC}				; pop(PC);
								;
	
	END	
; Note this program was written by Niall Hunt in 2016
