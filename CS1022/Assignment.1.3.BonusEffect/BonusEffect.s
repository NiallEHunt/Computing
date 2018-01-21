; Note this program was written by Niall Hunt in 2017
	
	AREA	MotionBlur, CODE, READONLY
	IMPORT	main
	IMPORT	getPicAddr
	IMPORT	putPic
	IMPORT	getPicWidth
	IMPORT	getPicHeight
	EXPORT	start
	
	PRESERVE8
	
TRUE EQU 1
FALSE EQU 0

start

	BL	getPicAddr		; load the start address of the image in R4
	MOV	R4, R0
	BL	getPicHeight	; load the height of the image (rows) in R5
	MOV	R5, R0
	BL	getPicWidth		; load the width of the image (columns) in R6
	MOV	R6, R0
	
	MOV R0, R4
	MOV R1, R6
	MOV R2, R5
	MOV R3, #5
	BL edgeDetection
 
	BL	putPic			; re-display the updated image

stop	B	stop




; Name:			edgeDetection
; Parameters:	R0 = picStartAdr
;				R1 = picWidth
;				R2 = picHeight
;				R3 = sideOfMatrix
; Function:		Takes a picture and using a convolution matrix performs an edge detection. The result is 
;				only the edges in the image are shown.
; Return:		void
edgeDetection
	STMFD sp!, {R4-R11, LR}		; push(R4-R11, LR);
								;
	STMFD sp!, {R0-R3}			; push(R0-R3);
	BL copyImage				; copyImage();
	MOV R6, R0					; R6 = startAdrOfCopy;
	LDMFD sp!, {R0-R3}			; pop(R0-R3);
								;
	MOV R4, #0					; for(int j = 0;(j < picHeight);j++)
forJIndex						; {
	CMP R4, R2					;	for(int i = 0;(i < picWidth);i++)
	BGE endForJIndex			;	{
								;		
	MOV R5, #0					;		
forIIndex						;		
	CMP R5, R1					;		
	BGE endForIIndex			;		
								;		push(R0-R3);
	STMFD sp!, {R0-R3}			;		
	MOV R1, R5					;		
	MOV R2, R4					;		
								;
	BL averageMatrix			;		averageMatrix(picStartAdr, i, j, sideOfMatrix);
	LDMFD sp!, {R0-R3}			;		
								;		pop(R0-R3);
	ADD R5, R5, #1				;	}	
	B forIIndex					;
endForIIndex					;
								;
	ADD R4, R4, #1				;
	B forJIndex					; }
endForJIndex					;
								;
	LDMFD sp!, {R4-R11, PC}		; pop(R4-R11, PC);



; Note this program was written by Niall Hunt in 2017

; Name:			copyImage
; Parameters:	R0 = picStartAdr
;				R1 = picWidth
;				R2 = picHeight
; Function:		Copies the given picture to the address directly after it in memory
; Return:		R0 = start address of copied image
copyImage
	STMFD sp!, {R4-R10, LR}		; push(R4-R10, LR);
	MUL R9, R1, R2				; R9(offsetBetweenPics) = picHeight * picWidth;
	ADD R9, R9, #1				; R9++;
	LSL R9, R9, #2				; R9 *= 4;
								;
	MOV R3, #0					; for(int j = 0;(j < picHeight);j++)
JFor							; {
	CMP R3, R2					;	
	BGE endJFor					;	
								;	
	MOV R4, #0					;	for(int i = 0;(i < picWidth);i++)
IFor							;	{
	CMP R4, R1					;			
	BGE endIFor					;			
								;		
	MUL R7, R3, R1				;		R7(offset) = picWidth * j;	
	ADD R7, R7, R4				;		offset += i;
	LSL R7, R7, #2				;		offset *= 4;
	ADD R10, R7, R9				;		offsetForCopy = offset + offsetBetweenPics;
								;		
	LDR R8, [R0, R7]			;		pixel = memory.LoadWord(picStartAdr + offset);
	STR R8, [R0, R10]			;		memory.StoreWord(pixel, picStartAdr + offsetForCopy);
								;		
	ADD R7, R7, #1				;		
	ADD R4, R4, #1				;		
	B IFor						;		
endIFor							;	}
								;	
	ADD R3, R3, #1				;	
	B JFor						;		
endJFor							; }	
								;	
	ADD R0, R0, R9				; R0(startAdrOfCopy) = picStartAdr + offsetBetweenPics;	
								;	
	LDMFD sp!, {R4-R10, PC}		; pop(R4-R10, PC);
	
	
	
	
	
; Name: 		averageMatrix
; Parameters:	R0 = picStartAdr
;				R1 = i
;				R2 = j
;				R3 = sidesOfMatrix
; Function: 	This function uses the edge detection convolution matrix to find the new RGB values for each pixel. 
; Returns:		void
; Note this program was written by Niall Hunt in 2017

averageMatrix
	STMFD sp!, {R0-R11, LR}		; push(R0-R11, LR);
								;
	MOV R5, R1					; R5 = i;
	MOV R6, R2					; R6 = j;
								; 
	STMFD sp!, {R0,R3-R4}		; push(R0,R3-R4);
	BL getPicHeight				; 
	MOV R4, R0					; 
	BL getPicWidth				;
	MOV R2, R0					; R2(picWidth) = getPickWidth();
	MOV R1, R4					; R1(picHeight) = getPicHeight();
	LDMFD sp!, {R0, R3-R4}		; pop(R0, R3-R4)						
								
	MOV R9, #0					; for(int count = 0;(count < 3);count++)
forRGBInMatrix					; {
	CMP R9, #3					;		
	BGE endRGBForMatrix			;	
								;	
	MOV R12, #FALSE	
	MOV R4, #0					;	runningTotal = 0;
	STMFD sp!, {R3}				;	push(R3);
	STMFD sp!, {R0-R2}			;	push(R0-R2);
	MOV R0, R3					;	
	MOV R1, #2					;	divide(sideOfMatrix, 2);
	BL division					;	
	MOV R3, R2					;	R3 = deviation;
	LDMFD sp!, {R0-R2}			; 	pop(R0-R2);
								;	
	RSB R10, R3, #0				;	for(int countY = -deviation;(countY <= deviation);countY++)
YFor							;	{
	CMP R10, R3					;		
	BGT endYFor					;		
								;		
	MOV R12, #FALSE	
	ADD R8, R6, R10				;		R8(y) = j + countY;
								;			
	RSB R11, R3, #0				;		for(int countX = -deviation;(countX <= deviation);countX++)
XFor							;		{
	CMP R11, R3					;				
	BGT endXFor					;			
								;			
	CMP R10, #0					;			if(x == 0 && y == 0)
	BNE notIJ					;				boolean isZero = true;
	CMP R11, #0					;			
	BNE notIJ					;			
	MOV R12, #TRUE				;			
notIJ							;
								;
								;			R7(x) = i + count;
	ADD R7, R5, R11				;			
								;			
	CMP R7, #0					;			if(x < 0 || x >= picWidth)
	BLT xEqualI					;				x = i;
	CMP R7, R2					;			
	BLT xNotEqualI				;										
xEqualI							;			
	MOV R7, R5					;									
xNotEqualI						;			
								;			if(y < 0 || y >= picHeight)
	CMP R8, #0					;				y = j;
	BLT yEqualJ					;
	CMP R8, R1					;
	BLT yNotEqualJ				;		
yEqualJ							;
	MOV R8, R6					;
yNotEqualJ						;
								;
								;
	STMFD sp!, {R6, R10-R11}	;			push(R6, R10-R11);
								;		
	MUL R6, R8, R2				;			R6(offset) = y * picWidth;
	ADD R6, R6, R7				;			offset += x;
	LSL R6, R6, #2				;			offset *= 4;
	ADD R6, R6, R9				;			offset += count;
								;			
	MUL R10, R1, R2				;			R10(diffBetweenPics) = picHeight * picWidth;
	ADD R10, R10, #1			;			diffBetweenPics++;
	LSL R10, R10, #2			;			diffBetweenPics *= 4;
								;
	ADD R10, R10, R6			;		   	offsetForSecondPic = offset + diffBetweenPics;
	LDRB R11, [R0, R10]			;			R11(R/G/BValue) = memory.LoadByte(picStartAdr + offsetForSecondPic);
								;			
	CMP R12, #TRUE				;			
	BNE multiplyByMinusOne		;			if(isZero)
	LSL R4, R4, #4			;				R/G/BValue *= 8;
	B afterIf					;			else
multiplyByMinusOne				;				R/G/BValue += -1;
	RSB R4, R4, #0			;			
afterIf							;			
								;			
	ADD R4, R4, R11				;			runningTotal += R/G/BValue;
								;			
	LDMFD sp!, {R6, R10-R11}	;			pop(R6, R10-R11);
								;			
	ADD R11, R11, #1			;		}
	B XFor						;			
endXFor							;
								;	}
	ADD R10, R10, #1			;
	B YFor						;
endYFor							;
								;
	LDMFD sp!, {R3}				; 	pop(R3);
								;
	STMFD sp!, {R3, R7, R10}	;	push(R3, R7, R10);
								;
	MUL R10, R6, R2				;	R10 = picWidth * j;
	ADD R10, R10, R5			;	R10 += i;
	LSL R10, R10, #2			; 	R10 *= 4;
	ADD R10, R10, R9			;	R10 += count;	
								;
	CMP R4, #255				;	if(R/G/B value >= 255)
	BGT over255					;		R/G/BValue = 255;
	CMP R4, #0					;
	BGE afterCheck				;	if(R/G/BValue < 0)
	MOV R4, #0					;		R/G/BValue = 0;
	B afterCheck				;
over255							;
	MOV R4, #255				;
afterCheck						;
								;
; Note this program was written by Niall Hunt in 2017
								
	STRB R4, [R0, R10]			; 	memory.StoreByte(R/G/BValue, picStartAdr + offset);
								;
	LDMFD sp!, {R3, R7, R10}	; 	pop(R3, R7, R10);
								;
	ADD R9, R9, #1				;
	B forRGBInMatrix			;
endRGBForMatrix					; }
								;
	LDMFD sp!, {R0-R11, PC}		; pop(R0-R11, PC);
	
	
	
	
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
	
		
	END	
; Note this program was written by Niall Hunt in 2017
