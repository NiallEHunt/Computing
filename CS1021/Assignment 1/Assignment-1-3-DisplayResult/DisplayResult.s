; Note this program was written by Niall Hunt in 2016	
	AREA	DisplayResult, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start
		LDR R4, =0				; value = 0;
		LDR R5, =0				; lastChEntered = 0;
		LDR R6, =0				; count = 0;
		LDR R7, =0				; sum = 0;
		LDR R8, =0				; min = 0;
		LDR R9, =0				; max = 0;
		LDR R10, =0				; mean = 0;
		LDR R11, =0				; boolean isNegative = false;
		LDR R12, =0				; boolean firstChSpace = false;

		BL getkey				; ch = input.keyEntered();
		CMP R0, #0x0D			; if(ch == CR)
		BEQ endprogram			; {
		CMP R0, #0x20			;  	boolean finished = true;
		BNE numcheck			; } else if(ch == space)
		MOV R12, R0				; {
		B	stats				;	firstChSpace = true;
								; }
								; if(!finished)
while							; {
		BL	getkey				; 	while((ch = input.keyEntered()) != CR)
		CMP	R0, #0x0D			; 	{
		BEQ	enter 				; 	
		CMP R0, #0x20			; 	 	if(!firstChSpace && (ch != space))
		BEQ stats				;		{

numcheck
		CMP R0, #0x2D			;	  		if((ch = '-') && (lastChEntered != '-'))
		BNE notnegative			;			{
		CMP R11, #0x2D			;				boolean isNegativeNum = true;
		BEQ while				;		
		CMP R4, #0				;		
		BNE while				;		
		MOV R11, R0				;			
		BL sendchar				;				print(ch);
		B while					;			}
notnegative						;
		CMP R0, #0x30			;	 		if((ch >= '0') && (ch <= '9'))
		BLO while				;			{
		CMP R0, #0x39			;		
		BHI while				;		 	 	
		
		BL sendchar				;		   		print(ch);
		MOV R5, #10
		SUB R0, R0,#0x30 		;	 			value = ch - 0x30;
		MUL R4, R5,R4			;				total = total * 10;
		ADD R4, R4,R0			;	 			total = total + value;
		B 	while				;			}
								;		}
stats							;	 	
		CMP R5, #0x20			;		if(((lastChEntered != space) && (ch == space)) || ch == enter)
		BEQ while				;		{
		BL sendchar				;			print(ch);		
		B afterspcheck			;			
enter							;
		CMP R5, #0x20			;			if(lastChEntered != space)
		BEQ endwhile			;			{
afterspcheck					;		

; Note this program was written by Niall Hunt in 2016

								;				if(isNegative)
		CMP R11, #0x2D			;				{
		BNE afternegative		;					value = 0 - value;
		RSB R4, R4, #0			;				}
afternegative					;	
								;	
		ADD R7, R7,R4			;	  			sum = sum + value;
								;	
		CMP R6, #0				;	 			if(count = 0)
		BNE min					;				{
		MOV R8, R4				;					min = value;
		MOV R9, R4				;					max = value;
min								;				}
		CMP R4, R8				;				if(value < min)
		BGE afterMin			;				{
		MOV R8, R4				;					min = value;
afterMin						;				} else if(value > max)
		CMP R4, R9				;				{
		BLE afterMinMax			;					max = value;
		MOV R9, R4				;				}
afterMinMax						;	 
								;	
		CMP R12, #0x20			;				if((lastChEntered != space) && (lastChEntered != '-'))
		BEQ aftercount			;				{
		CMP R4, #0				;	
		BNE count				;	
		CMP R11, #0x2D			;	
		BEQ aftercount			;	
count							;	
		ADD R6, R6,#1			;	 				count = count + 1;
aftercount						;				}
								;			}
		MOV R4, #0				;			value = 0;		
		MOV R11, #0				;			isNegative = false;
		MOV R12, #0				;			firstChSpace = false;
		MOV R5, R0				;			lastChEntered = ch;
		CMP R0, #0x0D			;			if(ch == CR)
		BNE while				;			{
								;				finished = true;
								;			}
								;		}
endwhile						;	 }
								;	
		MOV R11, R7				;	 total = sum;
		MOV R12, R6				;	 numberOfNumbers = count;
		MOV R1, #0				;	 isNegative = false;
								;	
		CMP R11, #0				;	 if(total < 0)
		BGE startmean			;	 {
		RSB R11, R11,#0			;	 	total = Math.abs(total);
		MOV R4, #1				;	  	isNegative = true;
startmean						;	 }
		CMP R12, R11			;	 while(total > count)
		BGT endmean				;	 {
		SUB R11, R11,R12		;	 	total = total - numberOfNumbers;
		ADD R10, R10,#1			;		mean = mean + 1;
		B startmean				;	 }
endmean							; 	 	
								;	 
		MOV R0, #0x3A			; 	 print(':');
		BL sendchar				;
		MOV R0, #0x20			;	 print(' ');	
		BL sendchar				;
								;	
		CMP R4, #1				;	 if(isNegative)
		BNE display				;	 {
		MOV R0, #0x2D			;		print('-')
		BL sendchar				;	 }
display							;
								;
; Note this program was written by Niall Hunt in 2016
								
		MOV R0, #0				;	 digitToPrint = 0;
		MOV R1, #10				; 	 greatestPowerOfTen = 10;
		MOV R2, #10				;	 
		MOV R3, #0				;	 previousPowerOfTen = 0;
power							;
		CMP R10, R1				;	 while(greatestPowerOfTen <= mean)
		BLT endpower			;	 {
		MOV R4, R3				;	 	smallestPowerOfTen = previousPowerOfTen;
		MOV R3, R1				;	 	previousPowerOfTen = greatestPowerOfTen;
		MUL R1, R2, R1			;	 	greatestPowerOfTen *= 10;
		B power					;	 }
endpower						;
		CMP R1, #10				;	 if(greatestPowerOfTen == 10)
		BNE digitfinder			;	 {
		MOV R0, R10				;		print(mean);
		ADD R0, R0,#0x30		;
		BL sendchar				;
		B endprogram			;    }
								;	 else
digitfinder						;    {
								;     	while((mean != 0) && !valueDisplayed)	
								;       {
		CMP R3, R10				;			while(previousPowerOfTen <= mean)
		BGT enddigitfinder		;			{
		SUB R10, R10,R3			;				mean = mean - previousPowerOfTen;
		ADD R0, R0,#1			;				digitToPrint++;
		B digitfinder			;				remainder = mean;
								;			}
enddigitfinder					;	
		ADD R0, R0,#0x30		;			digitToPrint += 0x30;
		BL sendchar				; 	        print(digitToPrint);
		CMP R10, R4				;			if(smallestPowerOfTen <= mean)
		BGT display				;			{
		MOV R0, #0x30			;				print('0');
		BL sendchar				;			}
		CMP R10, #0				;			if(mean == 0)
		BNE display				;			{
		MOV R0, #0x30			;				print('0');
								;				valueDisplayed = true;
		BL sendchar				;			}
								;		}
endprogram						;	 }
stop	B	stop				; }

	END	
; Note this program was written by Niall Hunt in 2016
