; Include File for Team1_Final_Reservations.asm

INCLUDE Irvine32.inc

MakeReservation PROTO,
	rowSize:DWORD,
	movieSize:DWORD,
	invalidPTR:PTR BYTE

RemoveReservation PROTO,
	rowSize:DWORD,
	movieSize:DWORD,
	invalidPTR:PTR BYTE

GetSeatIndex PROTO,
	rowSize:DWORD,
	movieSize:DWORD,
	invalidPTR:PTR BYTE

MainMenu PROTO

ShowingsMenu PROTO

.data
;--------------------------------------------------------------------------------------
;Strings for reservation making and clarification.
;--------------------------------------------------------------------------------------
	makeRowPrompt		BYTE "Enter the row for the seat reservation that you wish to make (A-E): ", 0
	makeColPrompt		BYTE "Enter the seat number reservation that you wish to make (1-10): ", 0
	removeRowPrompt		BYTE "Enter the row for the seat reservation that you wish to remove (A-E): ", 0
	removeColPrompt		BYTE "Enter the seat number reservation that you wish to remove (1-10): ", 0
	makeSeatSuccess		BYTE "Your seat has been reserved.", 0dh, 0ah, 0
	makeSeatFailed		BYTE "That seat is already taken.", 0dh, 0ah, 0
	removeSeatSuccess	BYTE "Your reservation has been removed.", 0dh, 0ah, 0
	removeSeatFailed	BYTE "That seat does not have a reservation.", 0dh, 0ah, 0