; Edit Reservations			(_EditReservation.asm)
; Procedures for adding or removing Reservations

INCLUDE Team1Final.inc

.code
;---------------------------------------------------------------------
MakeReservation PROC USES ebx edx esi,
	rowSize:DWORD,
	movieSize:DWORD,
	invalidPtr:PTR BYTE
;
; This procedure reads input from user to determine if their seat
; reservation is already taken. If not, assign them that seat, and
; marks in the 2d array that the seat is taken.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for make reservation
; Returns:	AL = 1, if the seat has been reserved
;---------------------------------------------------------------------
	invoke	GetSeatIndex, rowSize, movieSize, invalidPtr
	cmp		esi, -1
	je		L3

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

	L3:
	ret
MakeReservation ENDP

;---------------------------------------------------------------------
RemoveReservation PROC USES ebx edx esi,
	rowSize:DWORD,
	movieSize:DWORD,
	invalidPtr:PTR BYTE
;
; This procedure reads input from the user to determine if a seat
; is indeed reserved in order to be able to remove the seat
; reservation.
; Receives:	EAX = the movie and time slot
;			EBX = size of prompt
;			EDX = prompt for remove reservation
; Returns:	AL = 1, if reservation was removed
;---------------------------------------------------------------------
	invoke	GetSeatIndex, rowSize, movieSize, invalidPtr
	cmp		esi, -1
	je		L3

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

	L3:
	ret
RemoveReservation ENDP


END