; Team 1: Aaron Latanzi, Jason Vergara, Nicholas Lopez
; Class: CIS123 Assembly Language
; File Name: Team1_Final_Reservations.asm
; Creation Date: 11/6/2020
; Program Description:	This program is implementing the reservation
;						part of our planned program for the final.
;						This program has 106 (minus 16 test lines of
;						lines of code = 90 lines) of code. Will
;						have more in final version when all parts
;						are merged.

INCLUDE Irvine32.inc
	
MakeReservation PROTO,
	rowSize:DWORD,
	movieSize:DWORD

RemoveReservation PROTO,
	rowSize:DWORD,
	movieSize:DWORD

GetSeatIndex PROTO,
	rowSize:DWORD,
	movieSize:DWORD

.data
;--------------------------------------------------------------------------------------
;Table for options to make or remove reservation
;--------------------------------------------------------------------------------------
OptionTable1 BYTE '1'                            
            DWORD SelAdd                      
EntrySize1 = ($ - OptionTable1)                   
            BYTE '2'                            
            DWORD SelRem     
CountEntries1 = ($ - OptionTable1) / EntrySize1 
;--------------------------------------------------------------------------------------
;Table for options 1-5 for user input
;--------------------------------------------------------------------------------------
OptionTable2 BYTE '1'                            
            DWORD SelectMovie1Time1                        
EntrySize2 = ($ - OptionTable2)                   
            BYTE '2'                            
            DWORD SelectMovie1Time2                         
            BYTE '3'                            
            DWORD SelectMovie2Time1                        
            BYTE '4'                            
            DWORD SelectMovie2Time2                        
			BYTE '5'                                            
            DWORD CancelSelection                       
CountEntries2 = ($ - OptionTable2) / EntrySize2    

;--------------------------------------------------------------------------------------
;String values displayed for the user menu
;--------------------------------------------------------------------------------------
Select1 BYTE "1. Movie 1. Time: 2:15PM", 0dh, 0ah, 0
Select2 BYTE "2. Movie 1. Time: 6:30PM", 0dh, 0ah, 0
Select3 BYTE "3. Movie 2. Time: 2:15PM", 0dh, 0ah, 0
Select4 BYTE "4. Movie 2. Time: 6:30PM", 0dh, 0ah, 0
Select5 BYTE "5. Cancel", 0dh, 0ah, 0
StringChoice1 BYTE "Select a movie and time option: ", 0

SelectAdd BYTE "1. Make Reservation", 0dh,0ah,0
SelectRem BYTE "2. Remove Reservation", 0dh,0ah,0
SelectDone BYTE "3. Exit Program", 0dh,0ah,0
StringAdd BYTE "Make Reservation Selected", 0dh, 0ah, 0
StringRem BYTE "Remove Reservation Selected", 0dh, 0ah, 0
StringAddOrRem BYTE "Select an option: ", 0

;--------------------------------------------------------------------------------------
;Strings displayed after selection made
;--------------------------------------------------------------------------------------
String1 BYTE "Movie 1 at 2:15PM selected", 0
String2 BYTE "Movie 1 at 6:30PM selected", 0
String3 BYTE "Movie 2 at 2:15PM selected", 0
String4	BYTE "Movie 2 at 6:30PM selected", 0
String5	BYTE "Selection cancelled", 0
String6 BYTE "Invalid selection", 0
	
;--------------------------------------------------------------------------------------
;3d array for reservations.
;--------------------------------------------------------------------------------------
reservationsTable	BYTE 16 DUP(0)
RowGapValue = ($ - reservationsTable)
					BYTE 16 DUP(0)
MovieGapValue = ($ - reservationsTable)
					BYTE 16 DUP(0)
					BYTE 16 DUP(0)
					BYTE 16 DUP(0)
					BYTE 16 DUP(0)
					BYTE 16 DUP(0)
					BYTE 16 DUP(0)

;--------------------------------------------------------------------------------------
;Strings for reservation making and clarification.
;--------------------------------------------------------------------------------------
	makeRowPrompt		BYTE "Enter the row for the seat reservation that you wish to make (A-B): ", 0
	makeColPrompt		BYTE "Enter the seat number reservation that you wish to make (1-16): ", 0
	removeRowPrompt		BYTE "Enter the row for the seat reservation that you wish to remove (A-B): ", 0
	removeColPrompt		BYTE "Enter the seat number reservation that you wish to remove (1-16): ", 0
	makeSeatSuccess		BYTE "Your seat has been reserved.", 0
	makeSeatFailed		BYTE "That seat is already taken.", 0
	removeSeatSuccess	BYTE "Your reservation has been removed.", 0
	removeSeatFailed	BYTE "That seat does not have a reservation.", 0

.code
main PROC
;--------------------------------------------------------------------------------------
;Displays the menu choices and asks the user to select an option
;--------------------------------------------------------------------------------------
	L1:
		call	Clrscr
		mov		edx, OFFSET SelectAdd		;StringAdd used for output
		call	WriteString					;Writes the StringAdd to output
		mov		edx, OFFSET SelectRem		;StringRem used for output
		call	WriteString					;Writes the StringRem to output
		mov		edx, OFFSET SelectDone		;SelectDone used for output
		call	WriteString					;Writes the SelectDone to output

		mov		edx, OFFSET StringAddOrRem	;StringAddOrRem used for output
		call	WriteString					;Writes the StringAddOrRem to output
		call	ReadChar					;Asks for user input
		call	WriteChar					;Display user input
		call	Crlf						;new line

		mov		esi, OFFSET OptionTable1	;point esi to the table1 address
		mov		ecx, CountEntries1			;
		call	Crlf						;new line

		L2:
			cmp		al, [esi]
			jne		L3
				call	NEAR PTR [esi + 1]
				push	ebx
				push	edx
				call	Crlf
				jmp		L4
			L3:
				add		esi, EntrySize1
			loop	L2
		L4:

		cmp		ecx, 0
		je		L11
		push	eax

		mov		edx, OFFSET Select1			;String1 used for output
		call	WriteString					;Writes the String1 to output
		mov		edx, OFFSET Select2			;String2 used for output
		call	WriteString					;Writes the String2 to output
		mov		edx, OFFSET Select3			;String3 used for output
		call	WriteString					;Writes the String3 to output
		mov		edx, OFFSET Select4			;String4 used for output
		call	WriteString					;Writes the String4 to output
		mov		edx, OFFSET Select5			;StringGoodbye used for output
		call	WriteString					;Writes the String5 to output

		mov		edx, OFFSET StringChoice1	;StringChoice1 used for output
		call	WriteString					;Writes the StringChoice1 to output
		mov		eax, 0
		call	ReadChar					;Asks for user input
		call	WriteChar					;Display user input
		call	Crlf						;new line

		mov		esi, OFFSET OptionTable2	;point esi to the table2 address
		mov		ecx, CountEntries2			;count of table entries or loop counter
		call	Crlf						;new line
		call	Clrscr						;

		L5:
			cmp		al, [esi]					;compares characters in table to al
			jne		L6							;if not matched, continues loop
				call	NEAR PTR [esi+1]			;if matched, call the corresponding procedure
				call	Crlf						;new line
				jmp		L7							;jump to label 4
			L6:             
				add esi, EntrySize2					;Go to the next entry in the table
			loop L5									;repeats until ecx=0
		L7:

		cmp		ecx, 0
		jne		L8
			mov		edx, OFFSET String6
			call	WriteString
			jmp		L1
		L8:
	
		sub		al, '0'
		cbw
		cmp		eax, 4
		ja		L1

		pop		ecx
		pop		edx
		pop		ebx

		cmp		cl, '1'
		jne		L9
			invoke	MakeReservation, RowGapValue, MovieGapValue
			jmp		L10
		L9:
			invoke	RemoveReservation, RowGapValue, MovieGapValue
		L10:
		call	WaitMsg
	jmp L1
	
	L11:
    call WaitMsg						;Waits until user presses a key
	exit
main ENDP

;---------------------------------------------------------------------
SelAdd PROC
;
; This procedure is what happens when the user selects the first
; choice in the first menu. Returns the makeRowPrompt offset and size.
; Receives:	Nothing
; Returns:	EBX = makeRowPrompt size.
;			EDX = makeRowPrompt offset.
;---------------------------------------------------------------------
    mov		edx, OFFSET StringAdd		;StringAdd used for output
    call	WriteString					;Writes the StringAdd to output

	mov		ebx, SIZEOF makeRowPrompt
	mov		edx, OFFSET makeRowPrompt
    ret									;returns to main procedure
SelAdd ENDP

;---------------------------------------------------------------------
SelRem PROC
;
; This procedure is what happens when the user selects the second
; choice in the first menu. Returns the removeRowPrompt offset and size.
; Receives:	Nothing
; Returns:	EBX = removeRowPrompt size.
;			EDX = removeRowPrompt offset.
;---------------------------------------------------------------------
    mov edx,OFFSET StringRem			;StringRem used for output
    call WriteString					;Writes the StringRem to output

	mov		ebx, SIZEOF removeRowPrompt
	mov		edx, OFFSET removeRowPrompt
    ret									;returns to main procedure
SelRem ENDP

SelectMovie1Time1 PROC
    mov edx,OFFSET String1			;String1 used for output
    call WriteString				;Writes the String1 to output
    ret								;returns to main procedure
SelectMovie1Time1 ENDP

SelectMovie1Time2 PROC
    mov edx,OFFSET String2			;String2 used for output
    call WriteString				;Writes the String2 to output
    ret								;returns to main procedure
SelectMovie1Time2 ENDP

SelectMovie2Time1 PROC
    mov edx,OFFSET String3			;String3 used for output
    call WriteString				;Writes the String3 to output
    ret								;returns to main procedure
SelectMovie2Time1 ENDP

SelectMovie2Time2 PROC
    mov edx,OFFSET String4			;String4 used for output
    call WriteString				;Writes the String4 to output
    ret								;returns to main procedure
SelectMovie2Time2 ENDP

CancelSelection PROC
    mov edx,OFFSET String5			;StringGoodbye used for output
    call WriteString				;Writes the StringGoodbye to output
    ret								;returns to main procedure
CancelSelection ENDP

;---------------------------------------------------------------------
MakeReservation PROC USES ebx edx esi,
	rowSize:DWORD,
	movieSize:DWORD
;
; This procedure reads input from user to determine if their seat
; reservation is already taken. If not, assign them that seat, and
; marks in the 2d array that the seat is taken.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for make reservation
; Returns:	AL = 1, if the seat has been reserved
;---------------------------------------------------------------------
	invoke	GetSeatIndex, rowSize, movieSize

	mov		al, [esi]
	cmp		al, 0
	je		L1
		mov		eax, 0
		mov		edx, OFFSET makeSeatFailed
		jmp		L2
	L1:
		inc		al
		mov		[esi], al
		mov		edx, OFFSET makeSeatSuccess
	L2:

	call	WriteString
	call	Crlf
	call	Crlf
	ret
MakeReservation ENDP

;---------------------------------------------------------------------
RemoveReservation PROC USES ebx edx esi,
	rowSize:DWORD,
	movieSize:DWORD
;
; This procedure reads input from the user to determine if a seat
; is indeed reserved in order to be able to remove the seat
; reservation.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for remove reservation
; Returns:	AL = 1, if reservation was removed
;---------------------------------------------------------------------
	invoke	GetSeatIndex, rowSize, movieSize

	mov		al, [esi]
	cmp		al, 0
	jne		L1
		mov		edx, OFFSET removeSeatFailed
		jmp		L2
	L1:
		dec		al
		mov		[esi], al
		inc		eax
		mov		edx, OFFSET removeSeatSuccess
	L2:

	call	WriteString
	call	Crlf
	call	Crlf
	ret
RemoveReservation ENDP

;---------------------------------------------------------------------
GetSeatIndex PROC USES eax ebx edx,
	rowSize:DWORD,
	movieSize:DWORD
;
; This is a helper procedure for the make and remove reservations
; procedures.
; Receives: EAX = movie and time slot
;			EBX = size of prompt
;			EDX = prompt for either make or remove reservation
; Returns:	ESI = index of input seat
;---------------------------------------------------------------------
	push	eax
	call	WriteString
	mov		eax, 0
	call	ReadChar
	call	WriteChar
	sub		al, 'A'
	cbw
	call	Crlf

	push	eax
	add		edx, ebx
	call	WriteString
	mov		eax, 0
	call	ReadDec
	dec		eax
	
	mov		ebx, eax
	pop		eax

	mul		rowSize
	add		eax, ebx

	mov		esi, OFFSET reservationsTable
	add		esi, eax
	pop		eax
	dec		eax
	mul		movieSize
	add		esi, eax

	ret
GetSeatIndex ENDP

END main