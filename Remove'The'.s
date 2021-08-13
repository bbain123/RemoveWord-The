			AREA prog, CODE, READWRITE
			ENTRY
			ADR r0, STRING  	;r0 used as STRING pointer
			ADR r1, STRING2		;r1 used as STRING2 pointer
			LDRB r2, EoS		;r2 set to end of string 
			LDRB r3,[r0]    	;r3 used as current character
			MOV r4, r0			;r4 used as temp STRING pointer
			
			
			BNE tCheck			;check first letter of srtring for t
	
Start		CMP r2,r3
			BEQ ending     		;exit loop if current character is null terminating
			MOV r4, r0     		;save position of r4 before checking next letters
			
		
spaceTest	CMP r3,#' '			;if its a space, check next letter for t
			BNE store			;else, store character at r0 
			LDRB r3, [r4, #1]!
			
tCheck		CMP r3, #'t'		;if its a t, check next letter for h
			BNE store			;else, store character at r0
			LDRB r3, [r4, #1]!
			
hCheck		CMP r3, #'h'    	;if its an h, check next letter for e
			BNE store			;else, store character at r0
			LDRB r3, [r4, #1]!
			
eCheck      CMP r3, #'e'		;if its an e, check next letter for space or for null
			BNE store			;else, store character at r0
			LDRB r3, [r4, #1]!
			
endTest		CMP r3, r12			;if string ends in ' the', dont add this to STRING2
			BEQ Loop			;end program
			
			CMP r3, #' '		;if its ' the ', only add the space at the end of ' the '
			MOVEQ r0, r4		;start the test over with r0 being the space character
			BEQ Start

			LDRBNE r3, [r0]     ;if its not space, word starts with 'the'
			STRB r3, [r1], #1   ;store the space in front of the word
			ADD r0,r0,#1		;point r0 to next character
			B Start				;start again
			
			
store		MOVNE r4, r0		
			LDRBNE r3, [r4]
			STRB r3, [r1], #1  ;add the current character to STRING2
			LDRB r3, [r0,#1]!
			
			B Start				;start again
			
ending		STRB r3, [r1]		;store null character at the end of STRING2
		
		
		
Loop		b 	Loop						;infinite loop to prevent program from continuing
			AREA prog, DATA, READWRITE
STRING		DCB "and the man said they must go"		;store STRING
EoS			DCB 0x00						;end of string character
STRING2 	space 0x7F     					;allocate 127 bytes for STRING2 (empty descending)
			END