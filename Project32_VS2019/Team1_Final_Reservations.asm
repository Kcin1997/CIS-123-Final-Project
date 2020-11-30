; Author: Jason Vergara
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

.data

;--------------------------------------------------------------------------------------
;Table for options 1-5 for user input
;--------------------------------------------------------------------------------------
OptionTable BYTE '1'                            
            DWORD SelectMovie1Time1                        
EntrySize = ($ - OptionTable)                   
            BYTE '2'                            
            DWORD SelectMovie1Time2                         
            BYTE '3'                            
            DWORD SelectMovie2Time1                        
            BYTE '4'                            
            DWORD SelectMovie2Time2                        
			BYTE '5'                            
            DWORD RemoveRes  
            BYTE '6'                            
            DWORD EXIT_PR                       
CountEntries = ($ - OptionTable) / EntrySize    

;--------------------------------------------------------------------------------------
;String values displayed for the user menu
;--------------------------------------------------------------------------------------
Select1 BYTE "1. Movie 1. Time: 2:15PM", 0dh,0ah,0
Select2 BYTE "2. Movie 1. Time: 6:30PM", 0dh,0ah,0
Select3 BYTE "3. Movie 2. Time: 2:15PM", 0dh,0ah,0
Select4 BYTE "4. Movie 2. Time: 6:30PM", 0dh,0ah,0
Select5 BYTE "5. Remove reservation", 0dh,0ah,0
Select6 BYTE "6. Exit Program", 0dh,0ah,0
StringChoice1 BYTE "Select a movie and time option: ", 0

;--------------------------------------------------------------------------------------
;Strings displayed after selection made
;--------------------------------------------------------------------------------------
String1 BYTE "Movie 1 at 2:15PM selected", 0
String2 BYTE "Movie 1 at 6:30PM selected", 0
String3 BYTE "Movie 2 at 2:15PM selected", 0
String4 BYTE "Movie 2 at 6:30PM selected", 0
String5 BYTE "Remove Reservation selected", 0
StringGoodbye BYTE "Goodbye!", 0
	

	movie1Time1Row1		BYTE 16 DUP(0)
	movie1Time1Row2		BYTE 16 DUP(0)
	movie1Time2Row1		BYTE 16 DUP(0)
	movie1Time2Row2		BYTE 16 DUP(0)
	movie2Time1Row1		BYTE 16 DUP(0)
	movie2Time1Row2		BYTE 16 DUP(0)
	movie2Time2Row1		BYTE 16 DUP(0)
	movie2Time2Row2		BYTE 16 DUP(0)
	rowGapValue			BYTE SIZEOF movie1Time1Row1
	movieGapValue		BYTE SIZEOF movie1Time1Row1 * 2						; 2 = number of rows
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
    mov edx, OFFSET Select1         ;String1 used for output
    call WriteString                ;Writes the String1 to output
    mov edx, OFFSET Select2         ;String2 used for output
    call WriteString                ;Writes the String2 to output
    mov edx, OFFSET Select3         ;String3 used for output
    call WriteString                ;Writes the String3 to output
    mov edx, OFFSET Select4         ;String4 used for output
    call WriteString                ;Writes the String4 to output
    mov edx, OFFSET Select5         ;String5 used for output
    call WriteString                ;Writes the String5 to output
	mov edx, OFFSET Select6         ;StringGoodbye used for output
    call WriteString                ;Writes the String6 to output
    mov edx, OFFSET StringChoice1   ;StringChoice1 used for output
    call WriteString                ;Writes the StringChoice1 to output
    call ReadChar                   ;Asks for user input
    call WriteChar                  ;Display user input
	call Crlf                       ;new line
    mov esi,OFFSET OptionTable      ;point esi to the table address
    mov ecx,CountEntries            ;count of table entries or loop counter
    call Crlf                       ;new line

	.if al == '5'
		mov eax, 5
		jmp	L6
	.endif

L1:
    cmp al,[esi]                    ;compares characters in table to al
    jne L2                          ;if not matched, continues loop
    call NEAR PTR [esi+1]           ;if matched, call the corresponding procedure
    call Crlf                       ;new line
    jmp L3                          ;jump to label 3
L2:             
    add esi,EntrySize               ;Go to the next entry in the table
loop L1								;repeats until ecx=0

L3:
	.if al == '1'
		mov	eax, 1						; Pass the choice from the menu (ex: movie1time1 = 1, movie1time2 = 2, movie2time1 = 3, movie2time2 = 4)
		jmp	L5
	.elseif al == '2'
		mov	eax, 2
		jmp	L5
	.elseif al == '3'
		mov	eax, 3
		jmp	L5
	.elseif al == '4'
		mov	eax, 4
		jmp	L5
	.elseif al == '6'
		mov	eax, 6
		jmp	L7
	.endif

L5:
	mov		ebx, SIZEOF makeRowPrompt	; Pass the size of the makerowprompt string
	mov		edx, OFFSET makeRowPrompt	; Pass the offset to the makerowprompt string
	sub		al, '0'
	call	MakeReservation
	jmp L7

L6:
	mov		ebx, SIZEOF removeRowPrompt
	mov		edx, OFFSET removeRowPrompt
	call	RemoveReservation


L7:
    call WaitMsg                    ;Waits until user presses a key

	exit
main ENDP

SelectMovie1Time1 PROC
    mov edx,OFFSET String1			;String1 used for output
    call WriteString                ;Writes the String1 to output
    ret                             ;returns to main procedure
SelectMovie1Time1 ENDP

SelectMovie1Time2 PROC
    mov edx,OFFSET String2			;String2 used for output
    call WriteString                ;Writes the String2 to output
    ret                             ;returns to main procedure
SelectMovie1Time2 ENDP

SelectMovie2Time1 PROC
    mov edx,OFFSET String3			;String3 used for output
    call WriteString                ;Writes the String3 to output
    ret                             ;returns to main procedure
SelectMovie2Time1 ENDP

SelectMovie2Time2 PROC
    mov edx,OFFSET String4			;String4 used for output
    call WriteString                ;Writes the String4 to output
    ret                             ;returns to main procedure
SelectMovie2Time2 ENDP

RemoveRes PROC
    mov edx,OFFSET String5			;String5 used for output
    call WriteString                ;Writes the String5 to output
	ret                             ;returns to main procedure
RemoveRes ENDP

EXIT_PR PROC
    mov edx,OFFSET StringGoodbye    ;StringGoodbye used for output
    call WriteString                ;Writes the StringGoodbye to output
    ret                             ;returns to main procedure
EXIT_PR ENDP


;---------------------------------------------------------------------
MakeReservation PROC USES ebx edx esi
;
; This procedure reads input from user to determine if their seat
; reservation is already taken. If not, assign them that seat, and
; marks in the 2d array that the seat is taken.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for make reservation
; Returns:	AL = 1, if the seat has been reserved
;---------------------------------------------------------------------
	call	GetSeatIndex

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
RemoveReservation PROC USES ebx edx esi
;
; This procedure reads input from the user to determine if a seat
; is indeed reserved in order to be able to remove the seat
; reservation.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for remove reservation
; Returns:	AL = 1, if reservation was removed
;---------------------------------------------------------------------
	call	GetSeatIndex

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
GetSeatIndex PROC USES eax ebx edx
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
	
	mov		ebx, 0
	mov		bl, al
	pop		eax

	mul		rowGapValue
	add		eax, ebx

	mov		esi, OFFSET movie1Time1Row1
	add		esi, eax
	pop		eax
	dec		eax
	mul		movieGapValue
	add		esi, eax

	ret
GetSeatIndex ENDP

END main