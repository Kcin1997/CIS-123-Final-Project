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
	movie1Time1Row1		BYTE 16 DUP(0)
	movie1Time1Row2		BYTE 16 DUP(0)
	movie1Time2Row1		BYTE 16 DUP(0)
	movie1Time2Row2		BYTE 16 DUP(0)
	movie2Time1Row1		BYTE 16 DUP(0)
	movie2Time1Row2		BYTE 16 DUP(0)
	movie2Time2Row1		BYTE 16 DUP(0)
	movie2Time2Row2		BYTE 16 DUP(0)
	rowGapValue			BYTE SIZEOF movie1Time1Row1
	movieGapValue		BYTE SIZEOF movie1Time1Row1 * 2														; 2 = number of rows
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
	; Erase everything in main, but take note of how to pass to each procedure.
	mov		eax, 1						; Pass the choice from the menu (ex: movie1time1 = 1, movie1time2 = 2, movie2time1 = 3, movie2time2 = 4)
	mov		ebx, SIZEOF makeRowPrompt	; Pass the size of the makerowprompt string
	mov		edx, OFFSET makeRowPrompt	; Pass the offset to the makerowprompt string
	call	MakeReservation
	mov		eax, 2
	call	MakeReservation
	mov		eax, 3
	call	MakeReservation

	mov		eax, 1
	mov		ebx, SIZEOF removeRowPrompt
	mov		edx, OFFSET removeRowPrompt
	call	RemoveReservation
	mov		eax, 2
	call	RemoveReservation
	mov		eax, 1
	call	RemoveReservation

	exit
main ENDP

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